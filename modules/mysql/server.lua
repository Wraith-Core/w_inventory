if not lib then return end

local nativeVorp = shared.framework == 'vorp' and require 'modules.mysql.vorp' or nil
local nativeRsg = shared.framework == 'rsg' and require 'modules.mysql.rsg' or nil

local Query = {
    SELECT_STASH = 'SELECT data FROM w_inventory WHERE owner = ? AND name = ?',
    UPDATE_STASH = 'UPDATE w_inventory SET data = ? WHERE owner = ? AND name = ?',

    UPSERT_STASH = 'INSERT INTO w_inventory (data, owner, name) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE data = VALUES(data)',
    INSERT_STASH = 'INSERT INTO w_inventory (owner, name) VALUES (?, ?)',

    -- horse saddlebags (glovebox) and wagon storages (trunk) live on the stables row
    SELECT_TRUNK = 'SELECT `{vehicle_column}` as id, trunk FROM `{vehicle_table}` WHERE `{vehicle_column}` = ?',
    UPDATE_TRUNK = 'UPDATE `{vehicle_table}` SET trunk = ? WHERE `{vehicle_column}` = ?',

    SELECT_GLOVEBOX = 'SELECT `{vehicle_column}` as id, glovebox FROM `{vehicle_table}` WHERE `{vehicle_column}` = ?',
    UPDATE_GLOVEBOX = 'UPDATE `{vehicle_table}` SET glovebox = ? WHERE `{vehicle_column}` = ?',

    UPDATE_PLAYER = 'UPDATE `{user_table}` SET inventory = ? WHERE `{user_column}` = ?',
    -- the same, only while that number still belongs to the players row the bag was loaded from
    -- (players.id): w_core moves a character to another number and may hand the old one to
    -- someone else at once (TransferNumber), and a save still on its way must not land on him
    UPDATE_PLAYER_ROW = 'UPDATE `{user_table}` SET inventory = ? WHERE `{user_column}` = ? AND id = ?',
    UPDATE_GATHERING_BAG = 'UPDATE players SET inventory = ? WHERE citizenid = ? AND (id = ? OR ? = 0) AND w_gather_revision = ?',
    SELECT_PLAYER = 'SELECT inventory FROM `{user_table}` WHERE `{user_column}` = ?',
}

-- ── one collation for the ids (utf8mb4_general_ci) ──────────────────────────
-- players.citizenid and the tables that store an id are utf8mb4_general_ci. MySQL refuses "="
-- between two columns of different implicit collations ("Illegal mix of collations"), so a table
-- left in another one breaks every JOIN or IN (SELECT ...) that meets players: w_admin's list of
-- blocked characters failed that way. The CREATE statements name the collation now; this converts
-- a table created before them, once (information_schema shows nothing left to do on the next
-- start). keep = { [table] = { [column] = 'its definition' } }: a column binary on purpose (JSON)
-- is put back after the conversion. A table is left as it is, with the reason printed, when a
-- unique key would merge two of its values under the new collation (the ALTER would stop on a
-- duplicate key, or two ids would become one) or when it holds a binary column nobody named.
local ID_COLLATION = 'utf8mb4_general_ci'
local function alignCollation(db, tag, tables, keep)
    keep = keep or {}
    for _, t in ipairs(tables) do
        local ok, err = pcall(function()
            local current = db.scalar.await('SELECT TABLE_COLLATION FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?', { t })
            if not current then return end
            local kept, todo, binary, needed = keep[t] or {}, {}, nil, current ~= ID_COLLATION
            for _, c in ipairs(db.query.await('SELECT COLUMN_NAME AS n, COLLATION_NAME AS k FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLLATION_NAME IS NOT NULL', { t }) or {}) do
                if c.k ~= ID_COLLATION and not kept[c.n] then
                    todo[c.n], needed = true, true
                    if c.k:sub(-4) == '_bin' then binary = c.n end
                end
            end
            if not needed then return end
            if binary then error(('column %s is binary and nobody said to keep it'):format(binary), 0) end
            -- every unique key holding a converted column, grouped the way the new collation compares
            local keys = {}
            for _, s in ipairs(db.query.await('SELECT INDEX_NAME AS i, COLUMN_NAME AS n, SUB_PART AS p FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND NON_UNIQUE = 0 ORDER BY INDEX_NAME, SEQ_IN_INDEX', { t }) or {}) do
                local key = keys[s.i] or { by = {}, set = {} }
                keys[s.i] = key
                local e = ('`%s`'):format(s.n)
                if todo[s.n] then e, key.text = ('CONVERT(`%s` USING utf8mb4) COLLATE %s'):format(s.n, ID_COLLATION), true end
                if tonumber(s.p) then e = ('LEFT(%s, %d)'):format(e, tonumber(s.p)) end
                key.by[#key.by + 1], key.set[#key.set + 1] = e, ('`%s` IS NOT NULL'):format(s.n)
            end
            for name, key in pairs(keys) do
                if key.text and (tonumber(db.scalar.await(('SELECT COUNT(*) FROM (SELECT 1 FROM `%s` WHERE %s GROUP BY %s HAVING COUNT(*) > 1) d')
                    :format(t, table.concat(key.set, ' AND '), table.concat(key.by, ', ')))) or 0) > 0 then
                    error(('unique key %s would merge two of its values'):format(name), 0)
                end
            end
            db.query.await(('ALTER TABLE `%s` CONVERT TO CHARACTER SET utf8mb4 COLLATE %s'):format(t, ID_COLLATION))
            for _, def in pairs(kept) do db.query.await(('ALTER TABLE `%s` MODIFY %s'):format(t, def)) end
            print(('^3[%s] %s converted to %s^0'):format(tag, t, ID_COLLATION))
        end)
        if not ok then print(('^1[%s] %s keeps its collation: %s^0'):format(tag, t, tostring(err))) end
    end
end

local databaseReady = promise.new()
local databaseReadyState
local databaseError

local function awaitDatabase()
    if databaseReadyState == nil then
        databaseReadyState = Citizen.Await(databaseReady)
    end

    if databaseReadyState ~= true then
        error(('w_inventory database setup failed: %s'):format(tostring(databaseError)), 2)
    end
end

Citizen.CreateThreadNow(function()
    local schemaOk, schemaError = xpcall(function()
    local playerTable, playerColumn, vehicleTable, vehicleColumn

    if shared.framework == 'rsg' then
        playerTable = 'players'
        playerColumn = 'citizenid'
        -- w_stables keeps horses in the VORP-style `stables` table (horseUUID statebag = stables.id);
        -- rsg-stables' `player_horses` only when that is the stables resource in use.
        vehicleTable = GetResourceState('w_stables') ~= 'missing' and 'stables' or 'player_horses'
        vehicleColumn = 'id'
    elseif shared.framework == 'qbr' then
        playerTable = 'players'
        playerColumn = 'citizenid'
        vehicleTable = 'horses'
        vehicleColumn = 'id'
    elseif shared.framework == 'vorp' then
        -- The key is the character's id and not the player's account, so every character has its own bag
        playerTable = 'characters'
        playerColumn = 'charidentifier'
        -- VORP's horses are in the stables table and not horses (that is the RSG schema)
        vehicleTable = 'stables'
        vehicleColumn = 'id'
    elseif shared.framework == 'wlib' then
        -- Universal w_lib mode: player bags persist inside w_inventory itself (no framework DB coupling).
        playerTable = 'w_inventory'
        playerColumn = 'owner'
        vehicleTable = 'stables'
        vehicleColumn = 'id'
    end

    if not playerTable then
        return error(("w_inventory has no database mapping for framework '%s'"):format(tostring(shared.framework)))
    end

    for k, v in pairs(Query) do
        Query[k] = v:gsub('{user_table}', playerTable):gsub('{user_column}', playerColumn):gsub('{vehicle_table}',
            vehicleTable):gsub('{vehicle_column}', vehicleColumn)
    end

    Wait(0)

    -- Create the stash table directly with IF NOT EXISTS (avoids a failing probe query on a fresh database).
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS `w_inventory` (
        `owner` varchar(60) DEFAULT NULL,
        `name` varchar(100) NOT NULL,
        `data` longtext DEFAULT NULL,
        `lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
        UNIQUE KEY `owner` (`owner`,`name`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]])

    -- a table created before the CREATE above named its collation is utf8_general_ci (3-byte):
    -- brought to utf8mb4_general_ci like players, once
    alignCollation(MySQL, 'w_inventory', { 'w_inventory' })

    -- rsg mode persists stashes in rsg-inventory's `inventories` table, which no core ships;
    -- created here so the first stash does not fail. UNIQUE on identifier backs the upserts.
    if nativeRsg then
        MySQL.query.await([[CREATE TABLE IF NOT EXISTS `inventories` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `identifier` VARCHAR(255) NOT NULL,
            `items` LONGTEXT DEFAULT NULL,
            PRIMARY KEY (`id`),
            UNIQUE KEY `identifier` (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]])
    end

    -- Check information_schema before inspecting the stables table so servers without a stables
    -- resource do not log a failed SQL query or warning on boot.
    local hasVehicleTable = MySQL.scalar.await(
        'SELECT 1 FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? LIMIT 1',
        { vehicleTable }
    )
    local result = nil
    if hasVehicleTable then
        local okCols, cols = pcall(MySQL.query.await, ('SHOW COLUMNS FROM `%s`'):format(vehicleTable))
        if okCols then result = cols end
    end

    if result then
        local glovebox, trunk

        for i = 1, #result do
            local column = result[i]
            if column.Field == 'glovebox' then
                glovebox = true
            elseif column.Field == 'trunk' then
                trunk = true
            end
        end

        if not glovebox then
			MySQL.query.await(('ALTER TABLE `%s` ADD COLUMN `glovebox` LONGTEXT NULL'):format(vehicleTable))
        end

        if not trunk then
			MySQL.query.await(('ALTER TABLE `%s` ADD COLUMN `trunk` LONGTEXT NULL'):format(vehicleTable))
        end
    end

    -- VORP owns character_inventories/items_crafted and loadout. Never create
    -- a second player inventory column for it.
    if not nativeVorp then
        success, result = pcall(MySQL.scalar.await, ('SELECT inventory FROM `%s` LIMIT 1'):format(playerTable))
        if not success then
            error(('Missing native inventory column on %s; install the framework schema first'):format(playerTable))
        end
        if shared.backend == 'wcore' then
            local exists = MySQL.scalar.await([[SELECT 1 FROM information_schema.COLUMNS
                WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='players' AND COLUMN_NAME='w_gather_revision']])
            if not exists then
                MySQL.query.await('ALTER TABLE players ADD COLUMN w_gather_revision BIGINT UNSIGNED NOT NULL DEFAULT 0')
            end
        end
    end

    local clearStashes = GetConvar('inventory:clearstashes', '6 MONTH')

    if clearStashes ~= '' then
        pcall(MySQL.query.await, ('DELETE FROM w_inventory WHERE lastupdated < (NOW() - INTERVAL %s)'):format(clearStashes))
    end
    end, debug.traceback)

    databaseError = schemaError
    databaseReady:resolve(schemaOk)

    if not schemaOk then error(schemaError, 0) end
end)

db = {}

local function successful(result)
    return result ~= nil and result ~= false
end

function db.setInventoryResolver(resolver)
    if nativeVorp and nativeVorp.setInventoryResolver then nativeVorp.setInventoryResolver(resolver) end
end

function db.registerNativeStash(name, isShared)
    if nativeVorp and nativeVorp.registerStash then return nativeVorp.registerStash(name, isShared) end
end

function db.playerExists(identifier)
    awaitDatabase()
    if shared.framework == 'wlib' then
        return MySQL.scalar.await("SELECT 1 FROM w_inventory WHERE owner = ? AND name = 'player'", { tostring(identifier) }) ~= nil
    end
    return MySQL.scalar.await(shared.framework == 'vorp'
        and 'SELECT charidentifier FROM characters WHERE charidentifier = ?'
        or 'SELECT citizenid FROM players WHERE citizenid = ?', { identifier }) ~= nil
end

function db.loadPlayer(identifier)
    awaitDatabase()
    if nativeVorp then return nativeVorp.loadPlayer(identifier) end
    if shared.framework == 'wlib' then
        local raw = MySQL.scalar.await("SELECT data FROM w_inventory WHERE owner = ? AND name = 'player'", { tostring(identifier) })
        return raw and json.decode(raw) or {}
    end
    local inventory = MySQL.prepare.await(Query.SELECT_PLAYER, { identifier })
    if nativeRsg then return nativeRsg.decode(inventory) end
    return inventory and json.decode(inventory)
end

-- The old resource can die with its last COMMIT still running on an oxmysql
-- connection. A plain MVCC read here would install the pre-award bag.
function db.loadGatheringBag(owner)
    awaitDatabase()
    local row
    local fenced = MySQL.startTransaction(function(query)
        local rows = query('SELECT id, inventory, w_gather_revision FROM players WHERE citizenid = ? FOR UPDATE', { owner })
        assert(type(rows) == 'table', 'Player inventory read failed')
        row = rows[1]
        return true
    end)
    assert(fenced == true, 'Could not lock the player inventory for loading')
    if not row then return {}, nil, 0 end -- the core may still be creating its first row
    return nativeRsg.decode(row.inventory), assert(tonumber(row.id)), assert(tonumber(row.w_gather_revision))
end

--- `rowId` (players.id, optional): the row the bag was loaded from; a row that no longer holds
--- the number (the character moved) is left alone, the answer stays true (nothing to retry: the
--- moved copy is re-keyed and saves again under its new number).
function db.savePlayer(owner, inventory, liveItems, rowId, gatherRevision)
    awaitDatabase()
    if nativeVorp then return nativeVorp.savePlayer(owner, inventory, liveItems) end
    if shared.framework == 'wlib' then
        return successful(MySQL.prepare.await(Query.UPSERT_STASH, { inventory, tostring(owner), 'player' }))
    end
    if nativeRsg then inventory = nativeRsg.encode(inventory) end
    rowId = tonumber(rowId)
    if gatherRevision ~= nil then
        rowId = rowId or 0
        local saved = MySQL.update.await(Query.UPDATE_GATHERING_BAG, { inventory, owner, rowId, rowId, gatherRevision })
        if saved == 1 then return true end
        -- An unchanged bag may report zero affected rows; a stale snapshot must not succeed.
        return saved == 0 and MySQL.scalar.await([[SELECT 1 FROM players WHERE citizenid = ? AND (id = ? OR ? = 0)
            AND w_gather_revision = ? AND BINARY inventory = BINARY ?]], { owner, rowId, rowId, gatherRevision, inventory }) ~= nil
    end
    if rowId then return successful(MySQL.prepare.await(Query.UPDATE_PLAYER_ROW, { inventory, owner, math.floor(rowId) })) end
    return successful(MySQL.prepare.await(Query.UPDATE_PLAYER, { inventory, owner }))
end

--- players.id of a character (nil when unknown or on VORP, whose bag is not a players column):
--- an offline edit names the row it read, so its write cannot land on a later holder of the number.
function db.playerRowId(identifier)
    awaitDatabase()
    if nativeVorp then return nil end
    local ok, id = pcall(MySQL.scalar.await, 'SELECT id FROM players WHERE citizenid = ?', { identifier })
    return ok and tonumber(id) or nil
end

function db.saveStash(owner, dbId, inventory, liveItems)
    awaitDatabase()
    if nativeRsg then
        local key = owner and owner ~= '' and (tostring(dbId) .. ':' .. tostring(owner)) or tostring(dbId)
        local encoded = nativeRsg.encode(inventory, nil, true)
        -- also the key and the value written: a save that crossed a move of its character takes
        -- back what it may have left under the old number (db.dropStaleStash)
        return successful(MySQL.prepare.await('INSERT INTO inventories (identifier, items) VALUES (?, ?) ON DUPLICATE KEY UPDATE items = VALUES(items)', { key, encoded })), key, encoded
    end
    if nativeVorp and nativeVorp.isNativeStash(owner, dbId) then
        return nativeVorp.saveStash(owner, dbId, inventory, liveItems)
    end
    return successful(MySQL.prepare.await(Query.UPSERT_STASH, { inventory, owner and tostring(owner) or '', dbId }))
end

--- A stash save that was on its way while its character moved to another number (w_core; the
--- copy is re-keyed by server_purge.lua) may have landed after the rename: then it made a new row
--- under the old key, which the number's next holder would inherit. That row goes, only while it
--- still holds exactly what the save wrote (landed before the rename, the row moved with the
--- character and nothing is left under the old key).
function db.dropStaleStash(key, encoded)
    awaitDatabase()
    if not nativeRsg or type(key) ~= 'string' or type(encoded) ~= 'string' then return false end
    return successful(MySQL.prepare.await('DELETE FROM inventories WHERE identifier = ? AND items = ?', { key, encoded }))
end

function db.loadStash(owner, name)
    awaitDatabase()
    if nativeRsg then
        local key = owner and owner ~= '' and (tostring(name) .. ':' .. tostring(owner)) or tostring(name)
        local data = MySQL.scalar.await('SELECT items FROM inventories WHERE identifier = ?', { key })
        return json.encode(nativeRsg.decode(data))
    end
    if nativeVorp and nativeVorp.isNativeStash(owner, name) then return nativeVorp.loadStash(owner, name) end
    return MySQL.prepare.await(Query.SELECT_STASH, { owner and tostring(owner) or '', name })
end

-- Atomic player/custody move. Explicitly include the player's post-move rows
-- so native ID resolution cannot interpret a transfer as a stack split.
function db.saveNativeTransfer(owner, name, playerRows, stashRows)
    awaitDatabase()
    if nativeVorp then
        return nativeVorp.saveInventories({ { playerRows, owner } }, { { stashRows, owner, name } })
    end
    if nativeRsg then
        local playerData, stashData = nativeRsg.encode(playerRows), nativeRsg.encode(stashRows)
        local key = tostring(name) .. ':' .. tostring(owner)
        return MySQL.startTransaction(function(query)
            local player = query('SELECT citizenid FROM players WHERE citizenid = ? FOR UPDATE', { owner })
            assert(player and player[1], 'Native inventory character does not exist')
            query('UPDATE players SET inventory = ? WHERE citizenid = ?', { playerData, owner })
            query('INSERT INTO inventories (identifier, items) VALUES (?, ?) ON DUPLICATE KEY UPDATE items = VALUES(items)', { key, stashData })
            return true
        end) == true
    end
    return false
end

function db.disposeNativeTransient(inv)
    if not nativeVorp then return true end
    awaitDatabase()
    return nativeVorp.disposeTransient(inv)
end

function db.saveGlovebox(id, inventory, liveItems)
    awaitDatabase()
    if nativeVorp then return nativeVorp.saveVehicle(id, 'glovebox', inventory, liveItems) end
    return successful(MySQL.prepare.await(Query.UPDATE_GLOVEBOX, { inventory, id }))
end

function db.loadGlovebox(id)
    awaitDatabase()
    if nativeVorp then return nativeVorp.loadVehicle(id, 'glovebox') end
    return MySQL.prepare.await(Query.SELECT_GLOVEBOX, { id })
end

function db.saveTrunk(id, inventory, liveItems)
    awaitDatabase()
    if nativeVorp then return nativeVorp.saveVehicle(id, 'trunk', inventory, liveItems) end
    return successful(MySQL.prepare.await(Query.UPDATE_TRUNK, { inventory, id }))
end

function db.loadTrunk(id)
    awaitDatabase()
    if nativeVorp then return nativeVorp.loadVehicle(id, 'trunk') end
    return MySQL.prepare.await(Query.SELECT_TRUNK, { id })
end

-- Saves are awaited and report failures. Native VORP containers share one
-- transaction so moved instance IDs cannot be deleted by the source save.
function db.saveInventories(players, trunks, gloveboxes, stashes, total)
    awaitDatabase()
    local results = { {}, {}, {}, {} }
    local nativePlayers, nativeStashes, nativeRefs = {}, {}, {}
    local allSaved = true

    local function save(index, rowIndex, callback, ...)
        local ok, result = pcall(callback, ...)
        local saved = ok and result == true
        results[index][rowIndex] = saved
        if not saved then
            allSaved = false
            warn(('Inventory save failed (%s:%s): %s'):format(index, rowIndex, tostring(result)))
        end
    end

    for index, row in ipairs(players) do
        if nativeVorp and nativeVorp.saveInventories then
            nativePlayers[#nativePlayers + 1] = row
            nativeRefs[#nativeRefs + 1] = { 1, index }
        else
            save(1, index, db.savePlayer, row[2], row[1], row[3])
        end
    end
    for index, row in ipairs(trunks) do save(2, index, db.saveTrunk, row[2], row[1]) end
    for index, row in ipairs(gloveboxes) do save(3, index, db.saveGlovebox, row[2], row[1]) end

    -- Accept the legacy flattened stash batch as well as rows. New inventory
    -- callers keep rows so each save can acknowledge the exact inventory.
    if #stashes > 0 and type(stashes[1]) ~= 'table' then
        local expanded = {}
        for i = 1, #stashes, 3 do expanded[#expanded + 1] = { stashes[i], stashes[i + 1], stashes[i + 2] } end
        stashes = expanded
    end
    for index, row in ipairs(stashes) do
        if nativeVorp and nativeVorp.saveInventories and nativeVorp.isNativeStash(row[2], row[3]) then
            nativeStashes[#nativeStashes + 1] = row
            nativeRefs[#nativeRefs + 1] = { 4, index }
        else
            save(4, index, db.saveStash, row[2], row[3], row[1], row[4])
        end
    end

    if #nativeRefs > 0 then
        local ok, result = pcall(nativeVorp.saveInventories, nativePlayers, nativeStashes)
        local saved = ok and result == true
        for _, ref in ipairs(nativeRefs) do results[ref[1]][ref[2]] = saved end
        if not saved then
            allSaved = false
            warn(('Native VORP inventory transaction failed: %s'):format(tostring(result)))
        end
    end
    return allSaved, results
end

return db
