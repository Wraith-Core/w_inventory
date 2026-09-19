-- VORP remains the authority for ownership. The W table stores only layout and
-- presentation metadata which have no columns in VORP's relational schema.
local Adapter = {}
local containers, registeredStashes, known = {}, {}, {}
local inventoryResolver = function() return {} end
local saving = false
local gunbelt, beltNames = {}, {}
function Adapter.configureGunbelt(mapping)
    gunbelt, beltNames = mapping, {}
    for ammoType, name in pairs(mapping) do beltNames[name] = ammoType end
end

local function copy(value)
    if type(value) ~= 'table' then return value end
    local result = {}
    for key, entry in pairs(value) do result[key] = copy(entry) end
    return result
end

local function decode(value)
    if type(value) == 'table' then return copy(value) end
    if value == nil or value == '' then return {} end
    local ok, result = pcall(json.decode, value)
    if not ok or type(result) ~= 'table' then error('Invalid VORP inventory JSON', 3) end
    return result
end

local function flag(value) return value == true or value == 1 or value == '1' end
local function identity(kind, id) return kind .. ':' .. tostring(id) end
local function slotId(row) return row and row.metadata and row.metadata._vorp end
local function isWeapon(name) return type(name) == 'string' and name:upper():sub(1, 7) == 'WEAPON_' end
local function account(name) return name == 'money' or name == 'gold' end

local function container(owner, name, shared)
    name = tostring(name or 'default')
    owner = shared and '' or tostring(owner or '')
    if not shared and not tonumber(owner) then error('VORP character id is required', 3) end
    return { owner = owner, name = name, shared = shared == true, key = name .. '\0' .. owner }
end

function Adapter.setInventoryResolver(resolver)
    assert(type(resolver) == 'function', 'inventory resolver must be a function')
    inventoryResolver = resolver
end

function Adapter.registerStash(name, shared)
    assert(type(name) == 'string' and name ~= '' and name ~= 'default', 'invalid native stash id')
    registeredStashes[name] = { shared = shared == true }
end

function Adapter.isNativeStash(_, name) return name ~= nil end

local function stash(owner, name)
    local config = registeredStashes[tostring(name)]
    return container(owner, name, config and config.shared or not owner or owner == '')
end

local function vehicleContainer(id, kind)
    assert(id ~= nil and tostring(id) ~= '', 'Native horse storage id is required')
    assert(kind == 'trunk' or kind == 'glovebox', 'Invalid native horse storage type')
    return container('', '__w_' .. kind .. ':' .. tostring(id), true)
end

local function liveContainer(inv)
    if not inv then return nil end
    if inv.type == 'player' or inv.player then return container(inv.owner, 'default') end
    if inv.type == 'trunk' or inv.type == 'glovebox' then return vehicleContainer(inv.dbId or inv.id, inv.type) end
    if inv.type == 'drop' or inv.type == 'temp' then
        return container('', '__w_' .. inv.type .. ':' .. tostring(inv.id), true)
    end
    if inv.type == 'stash' or inv.type == 'container' or inv.type == 'policeevidence' then
        return stash(inv.owner, inv.dbId or inv.id)
    end
    return nil
end

local function rowsFor(query, context, items)
    local sql = items and [[SELECT ci.character_id, ci.item_crafted_id AS id, ci.item_name AS name,
        ci.amount, ci.inventory_type, ci.degradation, ci.percentage, ic.metadata, ic.durability
        FROM character_inventories ci LEFT JOIN items_crafted ic ON ic.id = ci.item_crafted_id
        WHERE ci.inventory_type = ?]] or [[SELECT * FROM loadout WHERE curr_inv = ? AND dropped = 0]]
    local params = { context.name }
    if not context.shared then
        sql = sql .. (items and ' AND ci.character_id = ?' or ' AND charidentifier = ?')
        params[#params + 1] = tonumber(context.owner)
    end
    return query(sql .. (items and ' ORDER BY ci.item_crafted_id' or ' ORDER BY id'), params) or {}
end

local function ammoType(name)
    local ok, Items = pcall(require, 'modules.items.server')
    local definition = ok and Items(name)
    return definition and definition.ammoType
end

local function componentHash(value)
    if type(value) == 'number' then return value end
    if type(value) == 'string' and value ~= '' and value ~= 'nothing' then return joaat(value) end
end

local function activeAmmo(row, metadata)
    local requested = metadata.specialAmmo
    if type(requested) == 'string' then
        if requested:sub(1, 5) == 'AMMO_' then return requested end
        local ok, Items = pcall(require, 'modules.items.server')
        local special = ok and Items(requested)
        if special and special.ammoType then return special.ammoType end
    end
    return ammoType(row.name) or metadata._vorp and metadata._vorp.activeAmmo
end

function Adapter.weaponAmmo(row)
    local metadata = row.metadata or {}
    local native = metadata._vorp or {}
    local result = copy(native.ammo or {})
    local selected = activeAmmo(row, metadata)
    if selected then
        local amount = math.max(0, math.floor(tonumber(metadata.ammo) or 0))
        if selected == native.activeAmmo then
            amount = math.max(0, (tonumber(result[selected]) or 0) + amount - (tonumber(native.loadedAmmo) or amount))
        end
        result[selected] = amount
    end
    return result
end

function Adapter.weaponComponents(row)
    local metadata = row.metadata or {}
    local native = metadata._vorp or {}
    local original, wanted = native.components or {}, {}
    for _, value in pairs(metadata.components or {}) do wanted[tostring(componentHash(value))] = true end
    local result = {}
    for key, value in pairs(original) do
        local hash = componentHash(value)
        if hash and wanted[tostring(hash)] then result[key] = value; wanted[tostring(hash)] = nil end
    end
    for _, value in pairs(metadata.components or {}) do
        local hash = componentHash(value)
        if hash and wanted[tostring(hash)] then result[#result + 1] = value; wanted[tostring(hash)] = nil end
    end
    return result
end

local function layoutName(context) return '__vorp_layout:' .. context.name end

local function load(context)
    local query = MySQL.query.await
    local layoutRows = query('SELECT data FROM w_inventory WHERE owner = ? AND name = ?', { context.owner, layoutName(context) })
    local layout = layoutRows and layoutRows[1] and decode(layoutRows[1].data) or {}
    local result, occupied, snapshot, equipped = {}, {}, {}, {}
    local function push(row, metadata, kind)
        local id = assert(tonumber(row.id), 'VORP row has no persistent id')
        local key = identity(kind, id)
        local saved = layout[key] or {}
        local native = metadata._vorp
        for field, value in pairs(kind == 'weapon' and saved.metadata or {}) do
            if metadata[field] == nil and field ~= '_vorp' then metadata[field] = copy(value) end
        end
        metadata._vorp = native
        local slot = tonumber(saved.slot)
        if not slot or slot < 1 or slot % 1 ~= 0 or occupied[slot] then
            slot = 1
            while occupied[slot] do slot = slot + 1 end
        end
        occupied[slot] = true
        local entry = { name = row.name, count = kind == 'weapon' and 1 or tonumber(row.amount), slot = slot, metadata = metadata }
        result[#result + 1] = entry
        snapshot[key] = copy(entry)
        known[key] = { context = copy(context), name = row.name }
        if kind == 'weapon' and metadata.used then equipped[#equipped + 1] = entry end
    end
    for _, row in ipairs(rowsFor(query, context, true)) do
        if tonumber(row.amount) and tonumber(row.amount) > 0 then
            local metadata = decode(row.metadata)
            metadata._vorp = { kind = 'item', id = tonumber(row.id), originalEnvelope = copy(metadata._vorp), degradation = row.degradation,
                percentage = row.percentage, durability = row.durability, character = row.character_id }
            push(row, metadata, 'item')
        end
    end
    for _, row in ipairs(rowsFor(query, context, false)) do
        local ammo, components = decode(row.ammo), decode(row.comps)
        local selected = ammoType(row.name)
        if not selected or ammo[selected] == nil then
            for key in pairs(ammo) do if type(key) == 'string' then selected = key; break end end
        end
        local amount = math.max(0, math.floor(tonumber(selected and ammo[selected]) or 0))
        local native = { kind = 'weapon', id = tonumber(row.id), ammo = ammo, components = components,
            activeAmmo = selected, loadedAmmo = math.min(500, amount), nativeUsed2 = flag(row.used2), character = row.charidentifier }
        local metadata = { _vorp = native, serial = row.serial_number, ammo = native.loadedAmmo, components = {},
            used = flag(row.used) or flag(row.used2), used2 = false, label = row.custom_label and row.custom_label ~= '' and row.custom_label or row.label,
            custom_label = row.custom_label, custom_desc = row.custom_desc,
            weaponStatus = { degradation = tonumber(row.degradation) or 0, damage = tonumber(row.damage) or 0,
                dirt = tonumber(row.dirt) or 0, soot = tonumber(row.soot) or 0 } }
        metadata.durability = math.max(0.01, 100 * (1 - metadata.weaponStatus.degradation))
        for _, value in pairs(components) do
            local hash = componentHash(value)
            if hash then metadata.components[#metadata.components + 1] = hash end
        end
        push(row, metadata, 'weapon')
    end
    -- W marks the primary entry with used2; native VORP marks the offhand.
    if #equipped > 1 then
        for _, row in ipairs(equipped) do row.metadata.used2 = not row.metadata._vorp.nativeUsed2 end
    end
    if context.name == 'default' and next(gunbelt) then
        local characters = query('SELECT ammo FROM characters WHERE charidentifier = ?', { tonumber(context.owner) })
        local belt = decode(characters and characters[1] and characters[1].ammo)
        for ammoType, name in pairs(gunbelt) do
            local count = math.max(0, math.floor(tonumber(belt[ammoType]) or 0))
            if count > 0 then
                local slot = tonumber(layout['ammo:' .. ammoType] and layout['ammo:' .. ammoType].slot)
                if not slot or occupied[slot] then slot = 1; while occupied[slot] do slot = slot + 1 end end
                occupied[slot] = true
                result[#result + 1] = { name = name, slot = slot, count = count, metadata = {} }
            end
        end
    end
    containers[context.key] = { context = context, rows = snapshot }
    return result
end

function Adapter.loadPlayer(owner) return load(container(owner, 'default')) end
function Adapter.loadStash(owner, name) return json.encode(load(assert(stash(owner, name), 'unregistered VORP stash'))) end
function Adapter.loadVehicle(id, kind)
    return { [kind] = json.encode(load(vehicleContainer(id, kind))) }
end

local function snapshotRows(value)
    local result = {}
    for key, row in pairs(decode(value)) do
        if type(row) == 'table' and type(row.name) == 'string' and tonumber(row.count) and row.count > 0 and not account(row.name) then
            row.slot = tonumber(row.slot) or tonumber(key)
            assert(row.slot and row.slot > 0, 'Native inventory row has no slot')
            row.metadata = row.metadata or {}
            result[#result + 1] = row
        end
    end
    table.sort(result, function(a, b) return a.slot < b.slot end)
    return result
end

local function save(contexts)
    while saving do Wait(0) end
    saving = true
    local ok, result = xpcall(function()
        local selected, live, references = {}, {}, {}
        for _, spec in ipairs(contexts) do
            selected[spec.context.key] = spec
            spec.rows = snapshotRows(spec.rows)
        end
        for _, inv in pairs(inventoryResolver() or {}) do
            local context = liveContainer(inv)
            if context then
                live[context.key] = { context = context, rows = inv.items, live = inv.items }
                for _, row in pairs(inv.items or {}) do
                    local native = slotId(row)
                    if native and native.id then
                        local key = identity(native.kind, native.id)
                        references[key] = references[key] or {}
                        references[key][context.key] = true
                    end
                end
            end
        end
        -- Vehicle save callers may only provide serialized rows. Resolve their
        -- live table before the transaction so newly allocated IDs are published
        -- to the same slot instance, just as they are for players and stashes.
        for contextKey, spec in pairs(selected) do
            if not spec.live and live[contextKey] then spec.live = live[contextKey].live end
        end
        -- Saving the source first must not delete a row already moved to a live
        -- destination. Include all connected native inventories in one commit.
        local changed = true
        while changed do
            changed = false
            for contextKey, spec in pairs(selected) do
                local ids = {}
                for key in pairs(containers[contextKey] and containers[contextKey].rows or {}) do ids[key] = true end
                for _, row in ipairs(spec.rows) do
                    local native = slotId(row)
                    if native and native.id then ids[identity(native.kind, native.id)] = true end
                end
                for key in pairs(ids) do
                    for destination in pairs(references[key] or {}) do
                        if not selected[destination] then
                            local extra = live[destination]
                            selected[destination] = { context = extra.context, rows = snapshotRows(extra.rows), live = extra.live }
                            changed = true
                        end
                    end
                end
            end
        end
        local specs = {}
        for _, spec in pairs(selected) do specs[#specs + 1] = spec end
        table.sort(specs, function(a, b) return a.context.key < b.context.key end)
        local claims, pending, persisted = {}, {}, {}
        for _, spec in ipairs(specs) do
            spec.captured = {}
            for _, row in ipairs(spec.rows) do
                spec.captured[row.slot] = spec.live and spec.live[row.slot]
            end
        end
        -- Original owner retains the id when a stack is split across inventories.
        for _, spec in ipairs(specs) do
            for _, row in ipairs(spec.rows) do
                local native = slotId(row)
                if native and native.id then
                    local key = identity(native.kind, native.id)
                    assert(known[key] and known[key].name == row.name, 'Unknown or mismatched native inventory id')
                    local prior = claims[key]
                    if not prior or known[key].context.key == spec.context.key and prior.spec.context.key ~= spec.context.key then
                        claims[key] = { spec = spec, row = row }
                    end
                end
            end
        end
        local committed = MySQL.startTransaction(function(query)
            for _, spec in ipairs(specs) do
                local context, layout, kept = spec.context, {}, {}
                local character = tonumber(context.owner) or 0
                local identifier, belt = '', nil
                if context.name == 'default' then
                    local characters = query('SELECT identifier FROM characters WHERE charidentifier = ? LIMIT 1', { character })
                    assert(characters and characters[1], 'Native inventory character does not exist')
                    identifier = characters[1].identifier
                    if next(gunbelt) then
                        local native = query('SELECT ammo FROM characters WHERE charidentifier = ? FOR UPDATE', { character })
                        belt = decode(native and native[1] and native[1].ammo)
                        for ammoType in pairs(gunbelt) do belt[ammoType] = 0 end
                    end
                end
                local equipped = 0
                for _, row in ipairs(spec.rows) do if isWeapon(row.name) and flag(row.metadata.used) then equipped = equipped + 1 end end
                for _, row in ipairs(spec.rows) do
                    if beltNames[row.name] then
                        assert(belt, 'Gunbelt ammunition cannot be moved into item storage')
                        local ammoType = beltNames[row.name]
                        belt[ammoType] = belt[ammoType] + row.count
                        layout['ammo:' .. ammoType] = { slot = row.slot }
                    else
                    local metadata, kind = row.metadata, isWeapon(row.name) and 'weapon' or 'item'
                    local native = metadata._vorp or {}
                    local key = native.id and identity(kind, native.id)
                    local claim = key and claims[key]
                    local id = claim and claim.row == row and tonumber(native.id) or nil
                    local rowCharacter = context.shared and (tonumber(native.character) or 0) or character
                    if id then
                        local original = known[key]
                        local records = query(kind == 'weapon' and 'SELECT id, name, charidentifier AS owner, curr_inv AS container FROM loadout WHERE id = ? FOR UPDATE'
                            or 'SELECT item_crafted_id AS id, item_name AS name, character_id AS owner, inventory_type AS container FROM character_inventories WHERE item_crafted_id = ? FOR UPDATE', { id })
                        local record = records and records[1]
                        assert(record and record.name == row.name and record.container == original.context.name
                            and (original.context.shared or tostring(record.owner) == original.context.owner), 'Native inventory ownership changed')
                    end
                    if kind == 'weapon' then
                        local status = metadata.weaponStatus or {}
                        local ammo, components = Adapter.weaponAmmo(row), Adapter.weaponComponents(row)
                        local used = context.name == 'default' and flag(metadata.used)
                        local used2 = used and equipped > 1 and not flag(metadata.used2)
                        local values = { identifier, rowCharacter, row.name, json.encode(ammo), json.encode(components),
                            metadata.label or row.name, metadata.serial or '', metadata.custom_label or '', metadata.custom_desc or '',
                            tonumber(status.degradation) or 0, tonumber(status.damage) or 0, tonumber(status.dirt) or 0, tonumber(status.soot) or 0,
                            used and 1 or 0, used2 and 1 or 0, context.name }
                        if id then
                            values[#values + 1] = id
                            query([[UPDATE loadout SET identifier = ?, charidentifier = ?, name = ?, ammo = ?, comps = ?, label = ?,
                                serial_number = ?, custom_label = ?, custom_desc = ?, degradation = ?, damage = ?, dirt = ?, soot = ?,
                                used = ?, used2 = ?, curr_inv = ?, dropped = 0 WHERE id = ?]], values)
                        else
                            local inserted = query([[INSERT INTO loadout (identifier, charidentifier, name, ammo, comps, label, serial_number,
                                custom_label, custom_desc, degradation, damage, dirt, soot, used, used2, curr_inv, dropped)
                                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0)]], values)
                            id = assert(inserted and tonumber(inserted.insertId), 'Unable to allocate native weapon id')
                        end
                        native.ammo, native.components, native.activeAmmo, native.loadedAmmo = ammo, components, activeAmmo(row, metadata), metadata.ammo
                    else
                        local definitions = query('SELECT id FROM items WHERE item = ? LIMIT 1', { row.name })
                        local definition = definitions and definitions[1]
                        assert(definition and tonumber(definition.id), 'Item is absent from the native VORP items table: ' .. row.name)
                        local clean = copy(metadata)
                        clean._vorp = copy(native.originalEnvelope)
                        local durability = tonumber(native.durability) or 0
                        if id then
                            query('UPDATE items_crafted SET character_id = ?, item_id = ?, metadata = ?, item_name = ?, durability = ? WHERE id = ?',
                                { rowCharacter, definition.id, json.encode(clean), row.name, durability, id })
                            query([[UPDATE character_inventories SET character_id = ?, amount = ?, inventory_type = ?, item_name = ?,
                                degradation = ?, percentage = ? WHERE item_crafted_id = ?]],
                                { rowCharacter, row.count, context.name, row.name, tonumber(native.degradation) or 0, tonumber(native.percentage) or 100, id })
                        else
                            local inserted = query('INSERT INTO items_crafted (character_id, item_id, metadata, item_name, durability) VALUES (?, ?, ?, ?, ?)',
                                { rowCharacter, definition.id, json.encode(clean), row.name, durability })
                            id = assert(inserted and tonumber(inserted.insertId), 'Unable to allocate native item id')
                            query([[INSERT INTO character_inventories (character_id, item_crafted_id, amount, inventory_type, item_name, degradation, percentage)
                                VALUES (?, ?, ?, ?, ?, ?, ?)]],
                                { rowCharacter, id, row.count, context.name, row.name, tonumber(native.degradation) or 0, tonumber(native.percentage) or 100 })
                        end
                    end
                    native.id, native.kind, native.character = id, kind, rowCharacter
                    metadata._vorp = native
                    key = identity(kind, id)
                    kept[key] = copy(row)
                    persisted[key] = { context = copy(context), name = row.name }
                    layout[key] = { slot = row.slot, metadata = copy(metadata) }
                    layout[key].metadata._vorp = nil
                    pending[#pending + 1] = { spec = spec, row = row }
                    end
                end
                if belt then query('UPDATE characters SET ammo = ? WHERE charidentifier = ?', { json.encode(belt), character }) end
                spec.kept = kept
                query([[INSERT INTO w_inventory (owner, name, data) VALUES (?, ?, ?)
                    ON DUPLICATE KEY UPDATE data = VALUES(data)]], { context.owner, layoutName(context), json.encode(layout) })
            end
            for _, spec in ipairs(specs) do
                for key, old in pairs(containers[spec.context.key] and containers[spec.context.key].rows or {}) do
                    if not persisted[key] then
                        local native = slotId(old)
                        if native.kind == 'weapon' then
                            query('DELETE FROM loadout WHERE id = ? AND curr_inv = ? AND charidentifier = ?',
                                { native.id, spec.context.name, tonumber(native.character) or tonumber(spec.context.owner) or 0 })
                        else
                            query('DELETE FROM character_inventories WHERE item_crafted_id = ? AND inventory_type = ? AND character_id = ?',
                                { native.id, spec.context.name, tonumber(native.character) or tonumber(spec.context.owner) or 0 })
                            query('DELETE FROM items_crafted WHERE id = ? AND NOT EXISTS (SELECT 1 FROM character_inventories WHERE item_crafted_id = ?)', { native.id, native.id })
                        end
                    end
                end
            end
            return true
        end)
        if committed ~= true then return false end
        for _, spec in ipairs(specs) do containers[spec.context.key] = { context = spec.context, rows = spec.kept } end
        for key, value in pairs(persisted) do known[key] = value end
        -- Publish allocated ids only after commit, and only onto the same live
        -- slot instance captured at save time; a yielding save must not stamp a
        -- replacement item with the previous item's identity.
        local clientUpdates = {}
        for _, update in ipairs(pending) do
            local spec, row = update.spec, update.row
            local current = spec.live and spec.live[row.slot]
            if current and current == spec.captured[row.slot] and current.name == row.name then
                local old, native = slotId(current), slotId(row)
                if not isWeapon(row.name) or current.metadata.serial == row.metadata.serial then
                    current.metadata = current.metadata or {}
                    current.metadata._vorp = copy(native)
                    if not old or old.id ~= native.id then
                        clientUpdates[spec.context.key] = clientUpdates[spec.context.key] or { spec = spec, items = {} }
                        local updates = clientUpdates[spec.context.key].items
                        updates[#updates + 1] = { item = current }
                    end
                end
            end
        end
        for _, update in pairs(clientUpdates) do
            for _, inv in pairs(inventoryResolver() or {}) do
                if inv.items == update.spec.live and inv.syncSlotsWithClients then
                    for _, entry in ipairs(update.items) do entry.inventory = inv.id end
                    inv:syncSlotsWithClients(update.items, true)
                    break
                end
            end
        end
        return true
    end, debug.traceback)
    saving = false
    if not ok then error(result, 0) end
    return result
end

function Adapter.savePlayer(owner, rows, liveItems)
    return save({ { context = container(owner, 'default'), rows = rows, live = liveItems } })
end

function Adapter.saveStash(owner, name, rows, liveItems)
    return save({ { context = assert(stash(owner, name), 'unregistered native stash'), rows = rows, live = liveItems } })
end

function Adapter.saveVehicle(id, kind, rows, liveItems)
    return save({ { context = vehicleContainer(id, kind), rows = rows, live = liveItems } })
end

function Adapter.disposeTransient(inv)
    if not inv or (inv.type ~= 'drop' and inv.type ~= 'temp') then return true end
    local context = liveContainer(inv)
    -- Nothing was ever committed for this temporary container. Its original
    -- source inventory remains responsible for removing any unsaved rows.
    if not containers[context.key] then return true end
    return save({ { context = context, rows = {}, live = inv.items } })
end

function Adapter.saveInventories(players, stashes)
    local contexts = {}
    for _, row in ipairs(players or {}) do contexts[#contexts + 1] = { context = container(row[2], 'default'), rows = row[1], live = row[3] } end
    for _, row in ipairs(stashes or {}) do contexts[#contexts + 1] = { context = assert(stash(row[2], row[3])), rows = row[1], live = row[4] } end
    return save(contexts)
end

return Adapter
