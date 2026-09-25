local Inventory = require 'modules.inventory.server'
local Items = require 'modules.items.server'
require 'modules.bridge.rsg.compat'

local RSGCore = exports['rsg-core']:GetCoreObject()
local RSGShops = {}
local moneySync = {}
local Codec = require 'modules.mysql.rsg'
local replaceInventory

server.GetPlayerFromId = RSGCore.Functions.GetPlayer

local function resolveUsableCallback(value)
    if type(value) == 'function' then return value end
    if type(value) ~= 'table' then return nil end

    if rawget(value, '__cfx_functionReference') then return value end
    return value.cb or value.callback
end

local function usableCallback(itemName)
    local ok, value = pcall(RSGCore.Functions.CanUseItem, itemName)
    return ok and resolveUsableCallback(value) or nil
end

local function moneyAmount(Player, account)
    if not Player or not Player.PlayerData then return 0 end

    local functions = Player.Functions or {}
    if functions.GetMoney then
        local ok, amount = pcall(functions.GetMoney, account)
        if ok and tonumber(amount) then return tonumber(amount) end
    end

    local money = Player.PlayerData.money or {}
    return tonumber(money[account]) or 0
end

local function pushCurrency(Player)
    local data = Player and Player.PlayerData
    if not data or not data.source then return end

    local money = data.money or {}
    TriggerClientEvent('w_inventory:updateCurrency', data.source,
        tonumber(money.cash) or moneyAmount(Player, 'cash'),
        tonumber(money.gold or money.bloodmoney) or 0)
end

local function syncCashFromCore(Player)
    local data = Player and Player.PlayerData
    local inventory = data and Inventory(tonumber(data.source))
    if not inventory then return false end
    return Inventory.ReflectCash(inventory)
end

AddEventHandler('RSGCore:Server:OnPlayerUnload', server.playerDropped)

AddEventHandler('RSGCore:Server:OnJobUpdate', function(source, job)
    local inventory = Inventory(source)
    if not inventory then return end
    inventory.player.groups[inventory.player.job] = nil
    inventory.player.job = job.name
    inventory.player.groups[job.name] = job.grade.level
end)

AddEventHandler('RSGCore:Server:OnGangUpdate', function(source, gang)
    local inventory = Inventory(source)
    if not inventory then return end
    inventory.player.groups[inventory.player.gang] = nil
    inventory.player.gang = gang.name
    inventory.player.groups[gang.name] = gang.grade.level
end)


---@param item SlotWithItem?
---@return SlotWithItem?
local function setItemCompatibilityProps(item)
    if not item then return end

    local definition = Items(item.name)
    local currency = item.name == 'money' or item.name == 'gold'
    local row = currency and Codec.toNativeCurrency(item) or Codec.toNativeItem(item, definition)
    local native = RSGCore.Shared.Items[row.name] or {}
    for _, key in ipairs({ 'label', 'weight', 'image', 'unique', 'useable', 'shouldClose', 'description', 'combinable' }) do
        row[key] = native[key]
    end
    return row
end

local function compatibleItems(items)
    local compatible = {}

    for slot, item in pairs(items or {}) do
        if type(item) == 'table' and item.name and item.name ~= 'money' and item.name ~= 'gold' then
            local row = setItemCompatibilityProps(item)
            local definition = Items(item.name)
            row.slot = tonumber(item.slot) or tonumber(slot)
            compatible[row.slot] = row
        end
    end

    return compatible
end

local function normalizeOfflineItems(items)
    local converted = {}
    for _, data in ipairs(Codec.decode(items)) do
        local item = assert(Items(data.name), 'Native RSG item is missing from Shared.Items: ' .. data.name)
        local row = { name = item.name, label = item.label, slot = data.slot, count = data.count,
            description = item.description, metadata = data.metadata, stack = item.stack, close = item.close }
        row.weight = Inventory.SlotWeight(item, row)
        local _, quality, delete = require('modules.items.rsg_decay').update(row.metadata, item.nativeDefinition)
        if not (delete and quality and quality <= 0) then converted[row.slot] = row end
    end
    return converted
end

local function saveOfflineItems(playerData)
    if type(playerData) ~= 'table' or not playerData.citizenid then return false end

    local converted = normalizeOfflineItems(playerData.items or playerData.inventory or {}, playerData)
    local buffer = {}

    for slot, item in pairs(converted or {}) do
        buffer[#buffer + 1] = {
            name = item.name,
            count = item.count,
            slot = tonumber(item.slot) or tonumber(slot),
            metadata = type(item.metadata) == 'table' and next(item.metadata) and item.metadata or nil,
        }
    end

    -- an offline Player object is a copy read earlier: its players row (id) is named, so a copy of
    -- a character w_core has since moved to another number never writes over that number's next holder
    db.savePlayer(playerData.citizenid, next(buffer) and json.encode(buffer) or nil, nil, tonumber(playerData.id))
    return true
end

local function setCoreItems(Player, items)
    local compatible = compatibleItems(items)

    -- The Player object arrived through an event or an export, so it is a msgpack copy; only
    -- its funcrefs reach the core's real player. SetPlayerData keeps PlayerData.items in step
    -- with the bag for everything that reads it from the core (client PlayerData and the rest).
    local setPlayerData = Player.Functions and Player.Functions.SetPlayerData
    if setPlayerData then
        local ok, err = pcall(setPlayerData, 'items', compatible)
        if not ok then print(('^1[w_inventory/rsg]^7 SetPlayerData(items) failed: %s'):format(tostring(err))) end
    end

    Player.PlayerData.items = compatible
    Player.PlayerData.inventory = compatible
end

local function setupPlayer(Player)
    if not Player or not Player.PlayerData then return end

    local data = Player.PlayerData
    local source = tonumber(data.source)
    if not source or not data.citizenid then return end

    local charinfo = data.charinfo or {}
    data.inventory = data.items or data.inventory or {}
    data.identifier = data.citizenid
    data.name = ('%s %s'):format(charinfo.firstname or '', charinfo.lastname or '')

    if not Inventory(source) then
        server.setPlayerInventory(data)
    end

    local inventory = Inventory(source)
    if inventory then
        syncCashFromCore(Player)
        setCoreItems(Player, inventory.items)
        if Player.Functions.UpdatePlayerData then Player.Functions.UpdatePlayerData() end
    end
    pushCurrency(Player)

    Player.Functions = Player.Functions or {}
    if Player.Functions.__wInventoryInstalled then return end

    local function addPlayerMethod(name, callback)
        if RSGCore.Functions.AddPlayerMethod then -- a funcref (callable table) when the core came through exports
            RSGCore.Functions.AddPlayerMethod(source, name, callback)
        else
            Player.Functions[name] = callback
        end
    end

    addPlayerMethod('AddItem', function(item, amount, slot, info)
        return Inventory.AddItem(source, item, amount, info, slot) and true or false
    end)

    addPlayerMethod('RemoveItem', function(item, amount, slot)
        return Inventory.RemoveItem(source, item, amount, nil, slot) and true or false
    end)

    addPlayerMethod('GetItemBySlot', function(slot)
        return setItemCompatibilityProps(Inventory.GetSlot(source, slot))
    end)

    addPlayerMethod('GetItemByName', function(itemName)
        return setItemCompatibilityProps(Inventory.GetSlotWithItem(source, itemName))
    end)

    addPlayerMethod('GetItemsByName', function(itemName)
        local slots = Inventory.GetSlotsWithItem(source, itemName)
        if not slots then return {} end
        local results = {}
        for i, slot in pairs(slots) do
            results[i] = setItemCompatibilityProps(slot)
        end
        return results
    end)

    addPlayerMethod('ClearInventory', function(filterItems)
        Inventory.Clear(source, filterItems)
        return true
    end)

    addPlayerMethod('SetInventory', function(items)
        return replaceInventory and replaceInventory(source, items) or false
    end)

    Player.Functions.__wInventoryInstalled = true
end

AddEventHandler('RSGCore:Server:PlayerLoaded', setupPlayer)

SetTimeout(500, function()
    local ok, players = pcall(function()
        if type(RSGCore.Functions.GetRSGPlayers) == 'function' then
            return RSGCore.Functions.GetRSGPlayers()
        end
        if type(RSGCore.Functions.GetQBPlayers) == 'function' then
            return RSGCore.Functions.GetQBPlayers()
        end
    end)

    if ok and type(players) == 'table' then
        for _, Player in pairs(players) do setupPlayer(Player) end
        return
    end

    for _, playerId in ipairs(GetPlayers()) do
        setupPlayer(RSGCore.Functions.GetPlayer(tonumber(playerId)))
    end
end)

function server.UseItem(source, itemName, data)
    local cb = usableCallback(itemName)
    return cb and cb(source, data)
end

local nativeUseBusy = {}
local function useNativeItem(source, slot, name, serial)
    source, slot = tonumber(source), tonumber(slot)
    local player = source and server.GetPlayerFromId(source)
    local inv = source and Inventory(source)
    local row = inv and slot and inv.items[slot]
    if not player or not row or nativeUseBusy[source] then return false, 'not_ready' end
    if name and row.name:lower() ~= tostring(name):lower() then return false, 'item_changed' end
    local state = Player(source).state
    local metadata = player.PlayerData.metadata or {}
    if state.inv_busy or metadata.isdead or metadata.inlaststand or metadata.ishandcuffed then return false, 'busy' end
    local item = setItemCompatibilityProps(row)
    local weapon = item.type == 'weapon' or item.type == 'weapon_thrown' or item.type == 'equipment'
    if serial ~= nil and tostring(item.info.serie) ~= tostring(serial) then return false, 'item_changed' end
    if weapon and GetResourceState('rsg-weapons') ~= 'started' then return false, 'rsg_weapons_not_ready' end
    nativeUseBusy[source] = true
    local ok, accepted, reason = pcall(function()
        if item.type == 'weapon' then
            if item.info.serie == nil or tonumber(item.info.quality) == nil then return false, 'invalid_native_weapon' end
            local exists = MySQL.scalar.await('SELECT serial FROM player_weapons WHERE serial = ? AND citizenid = ? LIMIT 1',
                { item.info.serie, player.PlayerData.citizenid })
            if not exists then
                MySQL.insert.await('INSERT INTO player_weapons (serial, citizenid) VALUES (?, ?)',
                    { item.info.serie, player.PlayerData.citizenid })
            end
        end
        if Inventory(source) ~= inv or inv.items[slot] ~= row then return false, 'item_changed' end
        if item.type == 'weapon' then
            TriggerClientEvent('rsg-weapons:client:UseWeapon', source, item)
        elseif item.type == 'weapon_thrown' then
            TriggerClientEvent('rsg-weapons:client:UseThrownWeapon', source, item)
        elseif item.type == 'equipment' then
            TriggerClientEvent('rsg-weapons:client:UseEquipment', source, item)
        else
            server.UseItem(source, item.name, item)
        end
        return true
    end)
    nativeUseBusy[source] = nil
    if not ok then
        print(('[w_inventory/rsg] Native use failed: %s'):format(tostring(accepted)))
        return false, 'native_use_failed'
    end
    return accepted, reason
end
lib.callback.register('w_inventory:rsg:useItem', useNativeItem)
RegisterNetEvent('rsg-inventory:server:useItem', function(item)
    if type(item) == 'table' then useNativeItem(source, item.slot, item.name, item.info and item.info.serie) end
end)

AddEventHandler('RSGCore:Server:OnMoneyChange', function(src, account, amount, changeType)
    local player = server.GetPlayerFromId(src)
    if not player then return end

    pushCurrency(player)
    if tostring(account):lower() == 'cash' then syncCashFromCore(player) end
end)

---@diagnostic disable-next-line: duplicate-set-field
function server.setPlayerData(player)
    local corePlayer = RSGCore.Functions.GetPlayer(tonumber(player.source))
    player = corePlayer and corePlayer.PlayerData or player
    local job = player.job or { name = 'unemployed', grade = { level = 0 } }
    local gang = player.gang or { name = 'none', grade = { level = 0 } }
    local jobGrade = job.grade and (job.grade.level or job.grade) or 0
    local gangGrade = gang.grade and (gang.grade.level or gang.grade) or 0
    local groups = {
        [job.name or 'unemployed'] = tonumber(jobGrade) or 0,
        [gang.name or 'none'] = tonumber(gangGrade) or 0,
    }

    return {
        source = player.source,
        name = player.name or ('%s %s'):format(player.charinfo and player.charinfo.firstname or '', player.charinfo and player.charinfo.lastname or ''),
        groups = groups,
        sex = player.charinfo and player.charinfo.gender,
        dateofbirth = player.charinfo and player.charinfo.birthdate,
        job = job.name,
        gang = gang.name,
    }
end

---@diagnostic disable-next-line: duplicate-set-field
function server.inventoryLimits(source)
    local player = server.GetPlayerFromId(source)
    local data = player and player.PlayerData or {}
    return tonumber(data.slots) or shared.playerslots, tonumber(data.weight) or shared.playerweight
end

function server.nativeCashBalance(source)
    local player = server.GetPlayerFromId(source)
    return player and moneyAmount(player, 'cash') or nil
end

function server.syncInventory(inv)
    Inventory.SyncBearerCash(inv)
    local accounts = Inventory.GetAccountItemCounts(inv)

    if accounts then
        local player = server.GetPlayerFromId(inv.id)
        if not player or tostring(player.PlayerData.citizenid) ~= tostring(inv.owner) then return end

        setCoreItems(player, inv.items)
        if player.Functions.UpdatePlayerData then player.Functions.UpdatePlayerData() end

        -- A bag is a projection, never an authority that may overwrite a wallet.
        if accounts.money ~= moneyAmount(player, 'cash') then Inventory.ReflectCash(inv) end

        pushCurrency(player)
    end
end

---@diagnostic disable-next-line: duplicate-set-field
function server.hasLicense(inv, license)
    local player = server.GetPlayerFromId(inv.id)
    local metadata = player and player.PlayerData and player.PlayerData.metadata or {}
    local licences = metadata.licences or metadata.licenses or {}
    return licences[license]
end

--- Takes the framework's item rows and updates them to the bag's slot format, i.e.
--- ```
--- Old: {1:{"name": "bread", "amount": 1, "label": "Bread", "slot": 1}, 2:{"name": "water", "amount": 3, "label": "Water", "slot": 2}}
--- New: [{"slot":1,"name":"bread","count":1}, {"slot":2,"name":"water","count":3}]
---```
---@diagnostic disable-next-line: duplicate-set-field
function server.convertInventory(playerId, items)
    local converted = normalizeOfflineItems(items)
    -- SetInventory is also an item operation; currency remains core-owned.
    for slot, row in pairs(converted) do
        if row.name == 'money' or row.name == 'gold' then converted[slot] = nil end
    end
    local cash = server.nativeCashBalance(tonumber(playerId))
    if cash and cash > 0 then
        local slot = 1
        while converted[slot] do slot = slot + 1 end
        local item = Items('money')
        local row = { name = 'money', label = item.label, slot = slot, count = cash, metadata = {},
            stack = true, close = item.close }
        row.weight = Inventory.SlotWeight(item, row)
        converted[slot] = row
    end
    local weight = 0
    for _, row in pairs(converted) do weight = weight + row.weight end
    return converted, weight
end

replaceInventory = function(playerId, items)
    local inventory = Inventory(playerId)
    if not inventory or type(items) ~= 'table' then return false end

    local converted, totalWeight = server.convertInventory(playerId, items)
    if type(converted) ~= 'table' or totalWeight ~= totalWeight or totalWeight > inventory.maxWeight then
        return false
    end

    local updatesBySlot = {}

    for slot in pairs(inventory.items) do
        slot = tonumber(slot) or slot
        updatesBySlot[slot] = { item = { slot = slot }, inventory = inventory.id }
    end

    for slot, item in pairs(converted) do
        slot = tonumber(slot) or slot
        if type(slot) ~= 'number' or slot < 1 or slot > inventory.slots or slot % 1 ~= 0 then return false end
        updatesBySlot[slot] = { item = item, inventory = inventory.id }
    end

    local updates = {}
    for _, update in pairs(updatesBySlot) do updates[#updates + 1] = update end

    inventory.items = converted
    inventory.weight = totalWeight
    inventory.weapon = nil
    inventory.changed = true
    inventory:syncSlotsWithClients(updates, true)
    if server.syncInventory then server.syncInventory(inventory) end
    Inventory.Save(inventory)

    return true
end

---@diagnostic disable-next-line: duplicate-set-field
function server.isPlayerBoss(playerId)
    local Player = RSGCore.Functions.GetPlayer(playerId)
    local data = Player and Player.PlayerData
    return data and ((data.job and data.job.isboss) or (data.gang and data.gang.isboss)) == true or false
end

local function export(exportName, func)
    AddEventHandler(('__cfx_export_%s_%s'):format(string.strsplit('.', exportName, 2)), function(setCB)
        setCB(func or function()
            error(("export '%s' is not supported when using w_inventory"):format(exportName))
        end)
    end)
end

export('rsg-inventory.LoadInventory', function(playerId, citizenId)
    if not tonumber(playerId) then
        if not citizenId then return {} end
        local converted = normalizeOfflineItems(db.loadPlayer(citizenId) or {}, { citizenid = citizenId })
        return compatibleItems(converted)
    end

    playerId = tonumber(playerId)
    local player = RSGCore.Functions.GetPlayer(playerId)

    if player then
        setupPlayer(player)
    elseif citizenId then
        return compatibleItems(normalizeOfflineItems(db.loadPlayer(citizenId) or {}))
    end

    local inventory = Inventory(playerId)
    if not inventory then return {} end

    return compatibleItems(inventory.items)
end)

export('rsg-inventory.SaveInventory', function(playerId, offline)
    if offline == true or type(playerId) == 'table' then
        return saveOfflineItems(playerId)
    end

    playerId = tonumber(playerId)
    if not playerId then return false end

    return Inventory.Save(playerId)
end)

export('rsg-inventory.SetInventory', function(playerId, items)
    return replaceInventory(playerId, items)
end)

export('rsg-inventory.SetItemData', function(playerId, itemName, key, value, slot)
    if not itemName or not key then return false end

    local item = slot and Inventory.GetSlot(playerId, tonumber(slot))
        or Inventory.GetSlotWithItem(playerId, itemName)
    if not item or item.name:lower() ~= tostring(itemName):lower() then return false end

    if key == 'amount' or key == 'count' then
        local amount = tonumber(value)
        if not amount or amount < 0 or amount ~= amount then return false end
        amount = math.floor(amount)

        if amount > item.count then
            return Inventory.AddItem(playerId, item.name, amount - item.count, item.metadata, item.slot) == true
        elseif amount < item.count then
            return Inventory.RemoveItem(playerId, item.name, item.count - amount, item.metadata, item.slot) == true
        end

        return true
    end

    local metadata = table.clone(item.metadata or {})

    if key == 'info' or key == 'metadata' then
        metadata = type(value) == 'table' and table.clone(value) or {}
        metadata._w_rsg = (item.metadata or {})._w_rsg
    else
        metadata[key] = value
    end

    return Inventory.SetMetadata(playerId, item.slot, metadata) == true
end)

export('rsg-inventory.UseItem', function(itemName, ...)
    local callback = usableCallback(itemName)
    return callback and callback(...)
end)

local function slotsByItem(items, itemName)
    local slots = {}
    itemName = tostring(itemName or ''):lower()

    for slot, item in pairs(items or {}) do
        if type(item) == 'table' and tostring(item.name):lower() == itemName then
            slots[#slots + 1] = tonumber(item.slot) or tonumber(slot) or slot
        end
    end

    return slots
end

export('rsg-inventory.GetSlotsByItem', slotsByItem)
export('rsg-inventory.GetFirstSlotByItem', function(items, itemName)
    return slotsByItem(items, itemName)[1]
end)

export('rsg-inventory.GetItemBySlot', function(playerId, slotId)
    return setItemCompatibilityProps(Inventory.GetSlot(playerId, slotId))
end)

export('rsg-inventory.GetTotalWeight', function(items)
    if type(items) ~= 'table' then
        local inventory = Inventory(items)
        return inventory and inventory.weight or 0
    end

    local weight = 0
    for _, item in pairs(items) do
        if type(item) == 'table' then
            weight = weight + (tonumber(item.weight) or 0) * (tonumber(item.amount or item.count) or 0)
        end
    end
    return weight
end)

export('rsg-inventory.GetItemByName', function(playerId, itemName)
    return setItemCompatibilityProps(Inventory.GetSlotWithItem(playerId, itemName))
end)

export('rsg-inventory.GetItemsByName', function(playerId, itemName)
    local results = {}
    for _, item in pairs(Inventory.GetSlotsWithItem(playerId, itemName) or {}) do
        results[#results + 1] = setItemCompatibilityProps(item)
    end
    return results
end)

export('rsg-inventory.GetSlots', function(identifier)
    local inventory = Inventory(identifier)
    if not inventory then return 0, 0 end

    local used = 0
    for _ in pairs(inventory.items) do used = used + 1 end
    return used, math.max(0, inventory.slots - used)
end)

export('rsg-inventory.GetItemCount', function(playerId, items)
    if type(items) == 'table' then
        local count = 0
        for key, value in pairs(items) do
            local itemName = type(value) == 'string' and value or key
            count = count + (Inventory.GetItemCount(playerId, itemName) or 0)
        end
        return count
    end
    return Inventory.GetItemCount(playerId, items) or 0
end)

export('rsg-inventory.GetItemWeight', function(itemName)
    local item = Items(itemName)
    return item and item.weight or nil
end)

export('rsg-inventory.GetFreeWeight', function(identifier)
    local inventory = Inventory(identifier)
    return inventory and math.max(0, inventory.maxWeight - inventory.weight) or 0
end)

export('rsg-inventory.ForceDropItem', function(source, itemName, amount, metadata)
    local item = Items(itemName)
    amount = math.floor(tonumber(amount) or 1)
    if not item or amount < 1 then return false end

    local ped = GetPlayerPed(source)
    if not ped or ped <= 0 then return false end

    return exports.w_inventory:CustomDrop('ui_drop', {
        { item.name, amount, type(metadata) == 'table' and metadata or {} }
    }, GetEntityCoords(ped), math.max(1, amount), item.weight * amount) or false
end)

export('rsg-inventory.CanAddItem', function(playerId, itemName, amount)
    return (Inventory.CanCarryAmount(playerId, itemName) or 0) >= amount
end)

export('rsg-inventory.ClearInventory', function(playerId, filter)
    Inventory.Clear(playerId, filter)
end)

export('rsg-inventory.CloseInventory', function(playerId, inventoryId)
    local playerInventory = Inventory(playerId)

    if not playerInventory then return end

    local inventory = Inventory(playerInventory.open)

    if not inventoryId or not inventory or inventoryId == inventory.id then
        playerInventory:closeInventory()
    end
end)

export('rsg-inventory.OpenInventory', function(playerId, invId, data)
    if not invId then
        TriggerClientEvent('w_inventory:openInventory', playerId)
        return true
    end

    local inventory = Inventory(invId)

    if inventory then
        return exports.w_inventory:forceOpenInventory(playerId, inventory.type, inventory.id)
    end

    data = type(data) == 'table' and data or {}
    exports.w_inventory:RegisterStash(invId, data.label or tostring(invId),
        data.slots or 50, data.maxweight or data.maxWeight or 100000,
        data.owner, data.groups or data.jobs)

    return exports.w_inventory:forceOpenInventory(playerId, 'stash', invId)
end)

export('rsg-inventory.OpenInventoryById', function(playerId, targetId)
    exports.w_inventory:forceOpenInventory(playerId, 'player', targetId)
end)

export('rsg-inventory.DoesShopExist', function(shopName)
    return RSGShops[shopName]
end)

export('rsg-inventory.CreateShop', function(shop)
    RSGShops[shop.name] = true

    local items = {}

    if shop.items then
        for _, item in pairs(shop.items) do
            if item.name then
                items[#items + 1] = {
                    name = item.name,
                    price = item.price,
                    count = item.amount or item.count,
                    metadata = item.info or item.metadata,
                    slot = item.slot
                }
            end
        end
    end

    exports.w_inventory:RegisterShop(shop.name, {
        name = shop.label,
        inventory = items
    })
end)

export('rsg-inventory.OpenShop', function(source, name)
    TriggerClientEvent('rsg-inventory:client:OpenShop', source, name)
end)

export('rsg-inventory.AddItem', function(invId, itemName, amount, slot, metadata)
    return Inventory.AddItem(invId, itemName, amount, metadata, slot) and true
end)

export('rsg-inventory.RemoveItem', function(invId, itemName, amount, slot)
    return Inventory.RemoveItem(invId, itemName, amount, nil, slot) and true
end)

export('rsg-inventory.HasItem', function(source, items, amount)
    amount = amount or 1

    local count = Inventory.Search(source, 'count', items)

    if type(items) == 'table' and type(count) == 'table' then
        for _, v in pairs(count) do
            if v < amount then
                return false
            end
        end

        return true
    end

    return count >= amount
end)

export('rsg-inventory.CreateInventory', function(id, config)
    local label = config and config.label or id
    local maxWeight = config and config.maxweight or 100000
    local slots = config and config.slots or 50
    exports.w_inventory:RegisterStash(id, label, slots, maxWeight,
        config and config.owner, config and (config.groups or config.jobs))
    return true
end)

export('rsg-inventory.GetInventory', function(id)
    local inventory = Inventory(id)
    if not inventory then return nil end

    local items = {}
    for slot, item in pairs(inventory.items) do
        items[slot] = setItemCompatibilityProps(item)
    end

    return {
        id = inventory.id,
        label = inventory.label,
        items = items,
        maxweight = inventory.maxWeight,
        slots = inventory.slots,
    }
end)

export('rsg-inventory.GetInventoryItems', function(id, owner)
    local inventory = Inventory(type(id) == 'string' and { id = id, owner = owner } or id)
    return inventory and inventory.items or {}
end)

export('rsg-inventory.RegisterStash', function(id, label, slots, maxWeight, owner, groups, coords)
    exports.w_inventory:RegisterStash(id, label, slots, maxWeight, owner, groups, coords)
    return true
end)

export('rsg-inventory.RemoveInventory', function(id)
    Inventory.Remove(id)
    return true
end)

export('rsg-inventory.SaveStash', function(id) if id then Inventory.Save(id) end; return true end)
export('rsg-inventory.ClearStash', function(id) Inventory.Clear(id); return true end)

export('rsg-inventory.DeleteInventory', function(id)
    Inventory.Remove(id)
    return true
end)
