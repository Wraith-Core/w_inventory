-- ════════════════════════════════════════════════════════════════════════════
-- w_inventory · setup/import_framework.lua
-- Importing the framework's bag data (VORP/RSG/QBR) into our form - once.
--
-- ═══ Why it is needed at all ═══
--
-- Our bag reads the `inventory` column in the characters table. And VORP **does not store in it**:
-- the `characters.inventory` column is a remnant of VORP v1 that vorp_core still creates and
-- vorp_inventory does not use. The player's real data is in three tables:
--
--     character_inventories : character_id · item_name · amount
--                             · item_crafted_id · inventory_type
--                             ('default' = the player's bag . anything else = a stash)
--     items_crafted         : id . metadata (JSON) - the copy's metadata
--     loadout               : charidentifier · name · serial_number
--                             · ammo (JSON) · comps · used/used2 · curr_inv
--
-- So the player opens his bag on a VORP server and finds it empty: we read a column that was never filled
-- while his items are somewhere else.
--
-- And RSG/QBR store in `players.inventory` - and it is the **very column** we read,
-- so the problem there is the JSON's shape and not its place (`amount`/`info`/`slot` instead of
-- `count`/`metadata`). So the conversion is a form and not a moving of tables.
--
-- ═══ The contract ═══
--
--  1) **We never touch the framework's tables**: no deletion and no modification and no insertion in them.
--     They stay as they are letter for letter, so going back to vorp_inventory is possible with no loss.
--
--  2) **Once per character**. A marker in an independent table (w_inventory_migrated)
--     and not a column in the framework's table. And without it every restart used to wipe the players'
--     progress and put them back to the framework's old snapshot.
--
--  3) **A trial before the execution**: `/w_import dry` prints what would happen with no writing.
--
-- ═══ Usage ═══
--     w_import dry     - a report with no writing (always start with it)
--     w_import run     - the execution
--     w_import status  - how many characters were imported
--
-- They are typed in the **server console**. And a player inside the game needs the ACE `command` permission.
-- ════════════════════════════════════════════════════════════════════════════

if not IsDuplicityVersion() then return end

local MARKER_TABLE = 'w_inventory_migrated'

local function log(fmt, ...)
    print(('^3[w_import]^0 ' .. fmt):format(...))
end

local function decodeJson(text, fallback)
    if type(text) ~= 'string' or text == '' then return fallback end
    local ok, decoded = pcall(json.decode, text)
    if ok and type(decoded) == 'table' then return decoded end
    return fallback
end

local function query(sql, params)
    local ok, result = pcall(MySQL.query.await, sql, params)
    if not ok then return nil, tostring(result) end
    return result or {}
end

-- ── The marker table ───────────────────────────────────────────────────────────
-- Independent on purpose: we add no column to `characters` nor to `players` - the framework's tables
-- are not ours, and changing their schema complicates any going back.
local function ensureMarkerTable()
    MySQL.query.await(([[
        CREATE TABLE IF NOT EXISTS `%s` (
            `cid` VARCHAR(64) NOT NULL,
            `framework` VARCHAR(16) NOT NULL,
            `items` INT NOT NULL DEFAULT 0,
            `weapons` INT NOT NULL DEFAULT 0,
            `stashes` INT NOT NULL DEFAULT 0,
            `migrated_at` TIMESTAMP NOT NULL DEFAULT current_timestamp(),
            PRIMARY KEY (`cid`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ]]):format(MARKER_TABLE))
end

---@return table<string, boolean>
local function migratedSet()
    local rows = query(('SELECT cid FROM `%s`'):format(MARKER_TABLE)) or {}
    local set = {}
    for i = 1, #rows do set[tostring(rows[i].cid)] = true end
    return set
end

-- ════════════════════════════════════════════════════════════════════════════
-- VORP
-- ════════════════════════════════════════════════════════════════════════════

--- The ammunition balance from the ammo column in loadout.
--- VORP stores it as a table keyed by the bullet type `{ AMMO_REVOLVER = 24 }`, and our bag
--- keeps one number for this copy. We take the largest value: it is this weapon's balance, and the rest of
--- the keys are types it does not carry.
---@param raw string?
---@return number
local function vorpAmmoCount(raw)
    local decoded = decodeJson(raw, nil)
    if type(decoded) == 'number' then return math.max(0, math.floor(decoded)) end
    if type(decoded) ~= 'table' then return 0 end

    local best = 0
    for _, value in pairs(decoded) do
        local n = math.floor(tonumber(value) or 0)
        if n > best then best = n end
    end
    return best
end

--- The weapon's components from the comps column.
---@param raw any
---@return string[]?
local function vorpComponents(raw)
    local decoded = decodeJson(raw, nil)
    if type(decoded) ~= 'table' then return nil end

    local out = {}
    for _, value in pairs(decoded) do
        if type(value) == 'string' and value ~= '' then out[#out + 1] = value end
    end
    return #out > 0 and out or nil
end

--- Everything a VORP character owns, split by container.
---@param cid number
---@return table<string, table[]> byContainer  the key is 'default' or the stash's name
local function vorpCharacterData(cid)
    local byContainer = {}

    local function push(container, entry)
        container = (container == nil or container == '' ) and 'default' or tostring(container)
        byContainer[container] = byContainer[container] or {}
        local list = byContainer[container]
        entry.slot = #list + 1
        list[#list + 1] = entry
    end

    -- The items. A LEFT JOIN on purpose: a row with no items_crafted (old or
    -- deleted data) must be imported with no metadata and not dropped silently.
    local items = query([[
        SELECT ci.item_name, ci.amount, ci.inventory_type, ic.metadata
        FROM character_inventories ci
        LEFT JOIN items_crafted ic ON ic.id = ci.item_crafted_id
        WHERE ci.character_id = ?
    ]], { cid }) or {}

    for i = 1, #items do
        local row = items[i]
        local count = math.max(0, math.floor(tonumber(row.amount) or 0))

        if row.item_name and row.item_name ~= '' and count > 0 then
            local metadata = decodeJson(row.metadata, nil)
            if metadata and next(metadata) == nil then metadata = nil end

            push(row.inventory_type, {
                name = row.item_name,
                count = count,
                metadata = metadata,
            })
        end
    end

    -- The weapons. Every row is one copy, so the count is always 1.
    local weapons = query([[
        SELECT name, serial_number, ammo, comps, used, used2, curr_inv, custom_label
        FROM loadout WHERE charidentifier = ?
    ]], { cid }) or {}

    for i = 1, #weapons do
        local row = weapons[i]

        if row.name and row.name ~= '' then
            local metadata = {
                serial = row.serial_number ~= '' and row.serial_number or nil,
                ammo = vorpAmmoCount(row.ammo),
                components = vorpComponents(row.comps),
                label = row.custom_label ~= '' and row.custom_label or nil,
                -- used/used2 are a momentary equip state and not ownership: they are deliberately not imported so
                -- the player does not start with a weapon in his hand after the conversion.
            }

            push(row.curr_inv, {
                name = row.name,
                count = 1,
                metadata = metadata,
            })
        end
    end

    return byContainer
end

-- ════════════════════════════════════════════════════════════════════════════
-- RSG / QBR - the same column, a different shape
-- ════════════════════════════════════════════════════════════════════════════

--- @param raw string?
--- @return table[]? converted  nil if the form is already ours
local function rsgConvert(raw)
    local decoded = decodeJson(raw, nil)
    if type(decoded) ~= 'table' or next(decoded) == nil then return nil end

    local out, changed = {}, false

    for _, row in pairs(decoded) do
        if type(row) == 'table' and type(row.name) == 'string' and row.name ~= '' then
            -- RSG: amount + info + slot . us: count + metadata + slot
            local count = tonumber(row.count) or tonumber(row.amount) or 1
            local metadata = row.metadata or row.info

            if row.amount ~= nil or row.info ~= nil then changed = true end
            if type(metadata) ~= 'table' or next(metadata) == nil then metadata = nil end

            out[#out + 1] = {
                name = row.name,
                count = math.max(0, math.floor(count)),
                slot = tonumber(row.slot) or (#out + 1),
                metadata = metadata,
            }
        end
    end

    -- Already our form: do not rewrite it for nothing.
    if not changed then return nil end
    return out
end

-- ════════════════════════════════════════════════════════════════════════════
-- The execution
-- ════════════════════════════════════════════════════════════════════════════

local running = false

---@param apply boolean false = a report with no writing
local function importAll(apply)
    if running then return log('an operation is under way - wait') end
    running = true

    local framework = shared and shared.framework or nil
    local total = { chars = 0, items = 0, weapons = 0, stashes = 0, skipped = 0 }

    local ok, err = pcall(function()
        ensureMarkerTable()
        local done = migratedSet()

        if framework == 'vorp' then
            local chars = query('SELECT charidentifier FROM characters') or {}
            log('VORP: %d character(s) in the database . %d imported before', #chars, (function()
                local n = 0; for _ in pairs(done) do n = n + 1 end; return n
            end)())

            for i = 1, #chars do
                local cid = tonumber(chars[i].charidentifier)
                local key = tostring(cid)

                if not cid or done[key] then
                    total.skipped = total.skipped + 1
                else
                    local byContainer = vorpCharacterData(cid)
                    local bag = byContainer.default or {}
                    local items, weapons = 0, 0

                    for j = 1, #bag do
                        if bag[j].metadata and bag[j].metadata.serial ~= nil then
                            weapons = weapons + 1
                        elseif bag[j].count == 1 and bag[j].metadata and bag[j].metadata.ammo then
                            weapons = weapons + 1
                        else
                            items = items + 1
                        end
                    end

                    local stashCount = 0
                    for container in pairs(byContainer) do
                        if container ~= 'default' then stashCount = stashCount + 1 end
                    end

                    if #bag == 0 and stashCount == 0 then
                        total.skipped = total.skipped + 1
                    else
                        total.chars = total.chars + 1
                        total.items = total.items + items
                        total.weapons = total.weapons + weapons
                        total.stashes = total.stashes + stashCount

                        log('  character %s: %d item(s) . %d weapon(s) . %d stash(es)%s',
                            key, items, weapons, stashCount, apply and '' or '  (dry run)')

                        if apply then
                            MySQL.update.await(
                                'UPDATE characters SET inventory = ? WHERE charidentifier = ?',
                                { json.encode(bag), cid })

                            for container, list in pairs(byContainer) do
                                if container ~= 'default' then
                                    MySQL.query.await([[
                                        INSERT INTO w_inventory (owner, name, data) VALUES (?, ?, ?)
                                        ON DUPLICATE KEY UPDATE data = VALUES(data)
                                    ]], { key, container, json.encode(list) })
                                end
                            end

                            MySQL.query.await(([[
                                INSERT INTO `%s` (cid, framework, items, weapons, stashes)
                                VALUES (?, 'vorp', ?, ?, ?)
                                ON DUPLICATE KEY UPDATE migrated_at = current_timestamp()
                            ]]):format(MARKER_TABLE), { key, items, weapons, stashCount })
                        end
                    end
                end
            end

        elseif framework == 'rsg' or framework == 'qbr' then
            local chars = query('SELECT citizenid, inventory FROM players') or {}
            log('%s: %d player(s) in the database', framework, #chars)

            for i = 1, #chars do
                local key = tostring(chars[i].citizenid)
                local converted = not done[key] and rsgConvert(chars[i].inventory) or nil

                if not converted then
                    total.skipped = total.skipped + 1
                else
                    total.chars = total.chars + 1
                    total.items = total.items + #converted

                    log('  player %s: %d item(s)%s', key, #converted, apply and '' or '  (dry run)')

                    if apply then
                        MySQL.update.await('UPDATE players SET inventory = ? WHERE citizenid = ?',
                            { json.encode(converted), key })
                        MySQL.query.await(([[
                            INSERT INTO `%s` (cid, framework, items, weapons, stashes)
                            VALUES (?, ?, ?, 0, 0)
                            ON DUPLICATE KEY UPDATE migrated_at = current_timestamp()
                        ]]):format(MARKER_TABLE), { key, framework, #converted })
                    end
                end
            end

        else
            log('^1no importer for the framework '%s'^0', tostring(framework))
        end
    end)

    running = false

    if not ok then
        return log('^1stopped with an error: %s^0', tostring(err))
    end

    log('%s - characters %d . items %d . weapons %d . stashes %d . skipped %d',
        apply and '^2complete^0' or '^3a dry run (nothing was written)^0',
        total.chars, total.items, total.weapons, total.stashes, total.skipped)

    if not apply and total.chars > 0 then
        log('to execute: ^2w_import run^0   (take a backup of the database first)')
    end
end

-- ════════════════════════════════════════════════════════════════════════════
-- The automatic import at the first join
--
-- An alternative to the single batch, and better suited to a live server: every character is imported alone the moment
-- it joins, with no stopping the server and no query over thousands of rows at once.
--
-- ! Off by default - an operation on players' data does not start by itself:
--       setr w_inventory:autoimport 1
--
-- * It must happen **before** setPlayerInventory, that is, before the bag is read from the database.
--   After it the player has already loaded an empty bag, and any save writes it over what we imported.
-- ════════════════════════════════════════════════════════════════════════════

--- Importing one character if it has not been imported yet.
---@param cid string|number the character's id (charidentifier in VORP . citizenid in RSG/QBR)
---@return boolean imported
local function importCharacter(cid)
    if GetConvarInt('w_inventory:autoimport', 0) ~= 1 then return false end

    local key = tostring(cid)
    if key == '' or key == 'nil' then return false end

    local framework = shared and shared.framework or nil
    local imported = false

    local ok, err = pcall(function()
        ensureMarkerTable()

        local already = MySQL.scalar.await(
            ('SELECT 1 FROM `%s` WHERE cid = ?'):format(MARKER_TABLE), { key })
        if already then return end

        if framework == 'vorp' then
            local byContainer = vorpCharacterData(tonumber(cid))
            local bag = byContainer.default or {}
            local stashes = 0

            for container, list in pairs(byContainer) do
                if container ~= 'default' then
                    stashes = stashes + 1
                    MySQL.query.await([[
                        INSERT INTO w_inventory (owner, name, data) VALUES (?, ?, ?)
                        ON DUPLICATE KEY UPDATE data = VALUES(data)
                    ]], { key, container, json.encode(list) })
                end
            end

            MySQL.update.await('UPDATE characters SET inventory = ? WHERE charidentifier = ?',
                { json.encode(bag), tonumber(cid) })

            MySQL.query.await(([[
                INSERT INTO `%s` (cid, framework, items, weapons, stashes)
                VALUES (?, 'vorp', ?, 0, ?)
                ON DUPLICATE KEY UPDATE migrated_at = current_timestamp()
            ]]):format(MARKER_TABLE), { key, #bag, stashes })

            log('automatic import - character %s: %d row(s) . %d stash(es)', key, #bag, stashes)
            imported = true

        elseif framework == 'rsg' or framework == 'qbr' then
            local raw = MySQL.scalar.await('SELECT inventory FROM players WHERE citizenid = ?', { key })
            local converted = rsgConvert(raw)

            -- Already our form: we set the marker with no writing so we do not redo the check at every join.
            if converted then
                MySQL.update.await('UPDATE players SET inventory = ? WHERE citizenid = ?',
                    { json.encode(converted), key })
                log('automatic import - player %s: %d item(s)', key, #converted)
                imported = true
            end

            MySQL.query.await(([[
                INSERT INTO `%s` (cid, framework, items, weapons, stashes)
                VALUES (?, ?, ?, 0, 0)
                ON DUPLICATE KEY UPDATE migrated_at = current_timestamp()
            ]]):format(MARKER_TABLE), { key, framework, converted and #converted or 0 })
        end
    end)

    if not ok then
        log('^1the import of %s failed: %s^0', key, tostring(err))
        return false
    end

    return imported
end

exports('importFrameworkCharacter', importCharacter)

RegisterCommand('w_import', function(source, args)
    -- From inside the game: the ACE permission only. The console (source 0) is always allowed.
    if source ~= 0 and not IsPlayerAceAllowed(source, 'command') then return end

    local mode = tostring(args[1] or ''):lower()

    if mode == 'run' then
        importAll(true)
    elseif mode == 'dry' then
        importAll(false)
    elseif mode == 'status' then
        ensureMarkerTable()
        local rows = query(([[
            SELECT framework, COUNT(*) AS n, SUM(items) AS items, SUM(weapons) AS weapons
            FROM `%s` GROUP BY framework
        ]]):format(MARKER_TABLE)) or {}

        if #rows == 0 then
            log('no character has been imported yet')
        else
            for i = 1, #rows do
                log('%s: %s character(s) . %s item(s) . %s weapon(s)', tostring(rows[i].framework),
                    tostring(rows[i].n), tostring(rows[i].items), tostring(rows[i].weapons))
            end
        end
    else
        log('w_import dry   - a report with no writing')
        log('w_import run   - the execution')
        log('w_import status- what was imported')
    end
end, false)
