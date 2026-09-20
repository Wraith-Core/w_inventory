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
    SELECT_PLAYER = 'SELECT inventory FROM `{user_table}` WHERE `{user_column}` = ?',
}

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
    end

    if not playerTable then
        return error(("w_inventory has no database mapping for framework '%s'"):format(tostring(shared.framework)))
    end

    for k, v in pairs(Query) do
        Query[k] = v:gsub('{user_table}', playerTable):gsub('{user_column}', playerColumn):gsub('{vehicle_table}',
            vehicleTable):gsub('{vehicle_column}', vehicleColumn)
    end

    Wait(0)

    local success, result = pcall(MySQL.scalar.await, 'SELECT 1 FROM w_inventory')

    if not success then
		MySQL.query.await([[CREATE TABLE IF NOT EXISTS `w_inventory` (
			`owner` varchar(60) DEFAULT NULL,
			`name` varchar(100) NOT NULL,
			`data` longtext DEFAULT NULL,
			`lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
			UNIQUE KEY `owner` (`owner`,`name`)
		)]])
    else
        -- Shouldn't be needed anymore; was used for some data conversion for v2.5.0 (back in March 2022)
        -- result = MySQL.query.await("SELECT owner, name FROM w_inventory WHERE NOT owner = ''")

        -- if result and next(result) then
        -- 	local parameters = {}
        -- 	local count = 0

        -- 	for i = 1, #result do
        -- 		local data = result[i]
        -- 		local snip = data.name:sub(-#data.owner, #data.name)

        -- 		if data.owner == snip then
        -- 			local name = data.name:sub(0, #data.name - #snip)

        -- 			count += 1
        -- 			parameters[count] = { query = 'UPDATE w_inventory SET `name` = ? WHERE `owner` = ? AND `name` = ?', values = { name, data.owner, data.name } }
        -- 		end
        -- 	end

        -- 	if #parameters > 0 then
        -- 		MySQL.transaction(parameters)
        -- 	end
        -- end
    end

    -- rsg mode persists stashes in rsg-inventory's `inventories` table, which no core ships;
    -- created here so the first stash does not fail. UNIQUE on identifier backs the upserts.
    if nativeRsg then
        MySQL.query.await([[CREATE TABLE IF NOT EXISTS `inventories` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `identifier` VARCHAR(255) NOT NULL,
            `items` LONGTEXT DEFAULT NULL,
            PRIMARY KEY (`id`),
            UNIQUE KEY `identifier` (`identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]])
    end

    -- The stables table may not exist at all (a server with no stables, say). The error here
    -- used to kill this thread so the rest of the tables were never set up.
    success, result = pcall(MySQL.query.await, ('SHOW COLUMNS FROM `%s`'):format(vehicleTable))

    if not success then
        result = nil
        warn(('no `%s` table - horse storage disabled'):format(vehicleTable))
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
    return MySQL.scalar.await(shared.framework == 'vorp'
        and 'SELECT charidentifier FROM characters WHERE charidentifier = ?'
        or 'SELECT citizenid FROM players WHERE citizenid = ?', { identifier }) ~= nil
end

function db.loadPlayer(identifier)
    awaitDatabase()
    if nativeVorp then return nativeVorp.loadPlayer(identifier) end
    local inventory = MySQL.prepare.await(Query.SELECT_PLAYER, { identifier })
    if nativeRsg then return nativeRsg.decode(inventory) end
    return inventory and json.decode(inventory)
end

function db.savePlayer(owner, inventory, liveItems)
    awaitDatabase()
    if nativeVorp then return nativeVorp.savePlayer(owner, inventory, liveItems) end
    if nativeRsg then inventory = nativeRsg.encode(inventory) end
    return successful(MySQL.prepare.await(Query.UPDATE_PLAYER, { inventory, owner }))
end

function db.saveStash(owner, dbId, inventory, liveItems)
    awaitDatabase()
    if nativeRsg then
        local key = owner and owner ~= '' and (tostring(dbId) .. ':' .. tostring(owner)) or tostring(dbId)
        local encoded = nativeRsg.encode(inventory, nil, true)
        return successful(MySQL.prepare.await('INSERT INTO inventories (identifier, items) VALUES (?, ?) ON DUPLICATE KEY UPDATE items = VALUES(items)', { key, encoded }))
    end
    if nativeVorp and nativeVorp.isNativeStash(owner, dbId) then
        return nativeVorp.saveStash(owner, dbId, inventory, liveItems)
    end
    return successful(MySQL.prepare.await(Query.UPSERT_STASH, { inventory, owner and tostring(owner) or '', dbId }))
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
