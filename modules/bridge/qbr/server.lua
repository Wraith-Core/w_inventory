local Inventory = require 'modules.inventory.server'
local Items = require 'modules.items.server'
require 'modules.bridge.qbr.compat'

local QBR = exports['qbr-core']
local QBRShops = {}
local moneySync = {}
local replaceInventory

local function resolveUsableCallback(value)
    if type(value) == 'function' then return value end
    if type(value) ~= 'table' then return nil end

    if rawget(value, '__cfx_functionReference') then return value end
    return value.cb or value.callback
end

local function usableCallback(itemName)
    local ok, value = pcall(function() return QBR:CanUseItem(itemName) end)
    return ok and resolveUsableCallback(value) or nil
end

local function getPlayer(source)
    local ok, player = pcall(function() return QBR:GetPlayer(tonumber(source)) end)
    return ok and player or nil
end

local function compatibilityItem(item)
    if not item then return nil end

    local copy = {}
    for key, value in pairs(item) do copy[key] = value end
    copy.info = item.metadata
    copy.amount = item.count
    copy.type = item.type or (Items(item.name) and Items(item.name).weapon and 'weapon' or 'item')
    return copy
end

local function compatibleItems(items)
    local compatible = {}

    for slot, item in pairs(items or {}) do
        if type(item) == 'table' and item.name and item.name ~= 'money' and item.name ~= 'gold' then
            local row = compatibilityItem(item)
            local definition = Items(item.name)
            row.slot = tonumber(item.slot) or tonumber(slot)
            row.unique = definition and definition.stack == false or false
            row.useable = definition and definition.consume ~= nil or false
            row.shouldClose = definition and definition.close ~= false or true
            compatible[row.slot] = row
        end
    end

    return compatible
end

local function normalizeOfflineItems(items, playerData)
    local converted, usedSlots, nextSlot = {}, {}, 0
    local charinfo = type(playerData) == 'table' and playerData.charinfo or {}
    local owner = type(playerData) == 'table' and playerData.citizenid or nil
    local playerName = type(playerData) == 'table' and playerData.name or nil

    if not playerName or playerName == '' then
        playerName = ('%s %s'):format(charinfo and charinfo.firstname or '', charinfo and charinfo.lastname or '')
    end

    if playerName == ' ' or playerName == '' then playerName = tostring(owner or 'Unknown') end

    local fakeInventory = {
        id = owner,
        owner = owner,
        label = playerName,
        player = {
            name = playerName,
            sex = charinfo and charinfo.gender,
            dateofbirth = charinfo and charinfo.birthdate,
        },
    }

    local function availableSlot(preferred)
        preferred = tonumber(preferred)
        if preferred and preferred >= 1 and preferred % 1 == 0 and not usedSlots[preferred] then
            usedSlots[preferred] = true
            return preferred
        end

        repeat nextSlot += 1 until not usedSlots[nextSlot]
        usedSlots[nextSlot] = true
        return nextSlot
    end

    for key, data in pairs(type(items) == 'table' and items or {}) do
        local item = type(data) == 'table' and data.name and Items(data.name) or nil
        local count = item and math.floor(tonumber(data.count or data.amount) or 1) or 0

        if item and count > 0 then
            local metadata = data.metadata ~= nil and data.metadata or data.info
            if type(metadata) == 'table' then metadata = table.clone(metadata) end

            if data.count ~= nil then
                if type(metadata) ~= 'table' then metadata = metadata and { type = metadata } or {} end
                metadata = Items.CheckMetadata(metadata, item, item.name, os.time())
                if not item.stack then count = 1 end
            else
                metadata, count = Items.Metadata(fakeInventory, item, metadata, count)
            end

            local slot = availableSlot(data.slot or key)
            local row = {
                name = item.name,
                label = item.label,
                slot = slot,
                count = count,
                description = item.description,
                metadata = metadata,
                stack = item.stack,
                close = item.close,
            }
            row.weight = Inventory.SlotWeight(item, row)
            converted[slot] = row
        end
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

    db.savePlayer(playerData.citizenid, next(buffer) and json.encode(buffer) or nil)
    return true
end

local function setCoreItems(player, items)
    -- QBR's built-in SaveInventory serialises amount/info. Never give it the
    -- internal w_inventory rows (count/metadata), otherwise a normal core save
    -- writes nil amounts back to the players table.
    local compatible = compatibleItems(items)

    player.PlayerData.items = compatible
    player.PlayerData.inventory = compatible
    if player.Functions.UpdatePlayerData then player.Functions.UpdatePlayerData() end
end

local function syncCashFromCore(player)
    if shared.backend ~= 'wcore' then return true end
    local source = player.PlayerData.source
    local inventory = Inventory(source)
    if not inventory or moneySync[source] then return end

    local cash = tonumber(player.Functions.GetMoney('cash')) or 0
    local current = Inventory.GetItemCount(source, 'money')
    if current == cash then return end

    moneySync[source] = true
    local ok, result = pcall(Inventory.SetItem, source, 'money', cash)
    moneySync[source] = nil

    if not ok then
        print(('^1[w_inventory/qbr]^7 failed to sync cash into inventory: %s'):format(tostring(result)))
        return false
    end

    return result
end

local function pushCurrency(player)
    local data = player and player.PlayerData
    local money = data and data.money or {}
    if not data or not data.source then return end

    TriggerClientEvent('w_inventory:updateCurrency', data.source,
        tonumber(money.cash) or 0, tonumber(money.gold or money.bloodmoney) or 0)
end

local function installPlayerMethods(player)
    local source = player.PlayerData.source
    local functions = player.Functions
    if functions.__wInventoryInstalled then return end
    functions.__wInventoryInstalled = true

    functions.AddItem = function(item, amount, slot, info)
        return Inventory.AddItem(source, item, amount, info, slot) and true or false
    end
    functions.RemoveItem = function(item, amount, slot)
        return Inventory.RemoveItem(source, item, amount, nil, slot) and true or false
    end
    functions.GetItemBySlot = function(slot)
        return compatibilityItem(Inventory.GetSlot(source, slot))
    end
    functions.GetItemByName = function(itemName)
        return compatibilityItem(Inventory.GetSlotWithItem(source, itemName))
    end
    functions.GetItemsByName = function(itemName)
        local slots = Inventory.GetSlotsWithItem(source, itemName) or {}
        local results = {}
        for i, item in pairs(slots) do results[i] = compatibilityItem(item) end
        return results
    end
    functions.ClearInventory = function(filterItems)
        Inventory.Clear(source, filterItems)
    end
    functions.SetInventory = function(items)
        return replaceInventory and replaceInventory(source, items) or false
    end

    for _, method in ipairs({ 'AddMoney', 'RemoveMoney', 'SetMoney' }) do
        local original = functions[method]
        if type(original) == 'function' then
            functions[method] = function(moneyType, ...)
                local result = original(moneyType, ...)
                if tostring(moneyType):lower() == 'cash' then syncCashFromCore(player) end
                pushCurrency(player)
                return result
            end
        end
    end
end

local function setupPlayer(player)
    if not player or not player.PlayerData then return end

    local data = player.PlayerData
    data.identifier = data.citizenid
    data.name = ('%s %s'):format(data.charinfo and data.charinfo.firstname or '', data.charinfo and data.charinfo.lastname or '')

    if not Inventory(data.source) then server.setPlayerInventory(data) end

    local inventory = Inventory(data.source)
    if not inventory then return end

    installPlayerMethods(player)
    setCoreItems(player, inventory.items)
    syncCashFromCore(player)
    pushCurrency(player)
end

AddEventHandler('QBCore:Server:PlayerLoaded', setupPlayer)
AddEventHandler('QBCore:Server:OnPlayerUnload', function(source) server.playerDropped(source) end)
AddEventHandler('playerDropped', function() server.playerDropped(source) end)
RegisterNetEvent('w_inventory:qbr:playerLogout', function()
    server.playerDropped(source)
end)

local function refreshGroups(source)
    local inventory = Inventory(source)
    if inventory and inventory.player then
        inventory.player = server.setPlayerData({ source = source })
    end
end

AddEventHandler('QBCore:Server:OnJobUpdate', function(source) refreshGroups(source) end)
AddEventHandler('QBCore:Server:OnGangUpdate', function(source) refreshGroups(source) end)
AddEventHandler('w_inventory:refreshPlayerData', refreshGroups)

SetTimeout(500, function()
    local ok, players = pcall(function() return QBR:GetQBPlayers() end)
    if ok and type(players) == 'table' then
        for _, player in pairs(players) do setupPlayer(player) end
        return
    end

    for _, playerId in ipairs(GetPlayers()) do
        setupPlayer(getPlayer(tonumber(playerId)))
    end
end)

---@diagnostic disable-next-line: duplicate-set-field
function server.GetPlayerFromId(source)
    return getPlayer(source)
end

---@diagnostic disable-next-line: duplicate-set-field
function server.UseItem(source, itemName, data)
    local callback = usableCallback(itemName)
    return callback and callback(source, data)
end

---@diagnostic disable-next-line: duplicate-set-field
function server.setPlayerData(player)
    local corePlayer = getPlayer(player.source)
    local data = corePlayer and corePlayer.PlayerData or player
    local job = data.job or {}
    local gang = data.gang or {}
    local jobGrade = job.grade and (job.grade.level or job.grade) or 0
    local gangGrade = gang.grade and (gang.grade.level or gang.grade) or 0

    return {
        source = data.source,
        name = data.name or GetPlayerName(data.source),
        groups = {
            [job.name or 'unemployed'] = tonumber(jobGrade) or 0,
            [gang.name or 'none'] = tonumber(gangGrade) or 0,
        },
        sex = data.charinfo and data.charinfo.gender,
        dateofbirth = data.charinfo and data.charinfo.birthdate,
        job = job.name,
        gang = gang.name,
    }
end

function server.nativeCashBalance(source)
    local player = getPlayer(source)
    return player and tonumber(player.Functions.GetMoney('cash')) or nil
end

function server.adjustNativeCash(source, delta)
    local player = getPlayer(source)
    local amount = tonumber(delta)
    if not player or not amount or amount == 0 then return false, 'invalid_count' end
    if amount > 0 then
        local ok = player.Functions.AddMoney('cash', amount, 'inventory-currency')
        pushCurrency(player)
        return ok ~= false
    else
        local need = -amount
        if (tonumber(player.Functions.GetMoney('cash')) or 0) < need then return false, 'not_enough_money' end
        local ok = player.Functions.RemoveMoney('cash', need, 'inventory-currency')
        pushCurrency(player)
        return ok ~= false
    end
end

---@diagnostic disable-next-line: duplicate-set-field
function server.syncInventory(inventory)
    local player = getPlayer(inventory.id)
    if not player then return end

    setCoreItems(player, inventory.items)
    if shared.backend ~= 'wcore' then return end

    local accounts = Inventory.GetAccountItemCounts(inventory)
    local cash = accounts and accounts.money
    if cash ~= nil and cash ~= player.Functions.GetMoney('cash') and not moneySync[inventory.id] then
        moneySync[inventory.id] = true
        player.Functions.SetMoney('cash', cash, 'w_inventory sync')
        moneySync[inventory.id] = nil
    end
end

---@diagnostic disable-next-line: duplicate-set-field
function server.hasLicense()
    return false
end

---@diagnostic disable-next-line: duplicate-set-field
function server.isPlayerBoss(source)
    local player = getPlayer(source)
    local data = player and player.PlayerData
    return data and ((data.job and data.job.isboss) or (data.gang and data.gang.isboss)) == true or false
end

---@diagnostic disable-next-line: duplicate-set-field
function server.convertInventory(playerId, oldItems)
    if type(oldItems) ~= 'table' then return {}, 0 end

    local converted, usedSlots, totalWeight, nextSlot = {}, {}, 0, 0

    local function availableSlot(preferred)
        preferred = tonumber(preferred)
        if preferred and preferred >= 1 and preferred % 1 == 0 and not usedSlots[preferred] then
            usedSlots[preferred] = true
            return preferred
        end

        repeat nextSlot += 1 until not usedSlots[nextSlot]
        usedSlots[nextSlot] = true
        return nextSlot
    end

    for key, old in pairs(oldItems) do
        local item = type(old) == 'table' and Items(old.name) or nil
        if item then
            local metadata, count = Items.Metadata(playerId, item, old.info or old.metadata, old.amount or old.count or 1)
            local targetSlot = availableSlot(old.slot or key)
            local row = {
                name = item.name,
                label = item.label,
                weight = 0,
                slot = targetSlot,
                count = count,
                description = item.description,
                metadata = metadata,
                stack = item.stack,
                close = item.close,
            }
            row.weight = Inventory.SlotWeight(item, row)
            totalWeight = totalWeight + row.weight
            converted[targetSlot] = row
        end
    end

    return converted, totalWeight
end

replaceInventory = function(source, items)
    local inventory = Inventory(source)
    if not inventory or type(items) ~= 'table' then return false end

    local converted, totalWeight = server.convertInventory(source, items)
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

local function aliasExport(name, callback)
    AddEventHandler(('__cfx_export_qbr-inventory_%s'):format(name), function(setCallback)
        setCallback(callback or function()
            error(("export '%s' is not supported by w_inventory's QBR bridge"):format(name))
        end)
    end)
end

aliasExport('LoadInventory', function(source, citizenId)
    if not tonumber(source) then
        if not citizenId then return {} end
        local converted = normalizeOfflineItems(db.loadPlayer(citizenId) or {}, { citizenid = citizenId })
        return compatibleItems(converted)
    end

    source = tonumber(source)
    local player = getPlayer(source)
    if player then
        setupPlayer(player)
    elseif not Inventory(source) and citizenId then
        server.setPlayerInventory({
            source = source,
            identifier = citizenId,
            name = GetPlayerName(source) or tostring(citizenId),
        })
    end

    local inventory = Inventory(source)
    if not inventory then return {} end

    return compatibleItems(inventory.items)
end)
aliasExport('SaveInventory', function(source, offline)
    if offline == true or type(source) == 'table' then
        return saveOfflineItems(source)
    end

    source = tonumber(source)
    if not source then return false end
    Inventory.Save(source)
    return true
end)
aliasExport('AddItem', function(id, item, amount, slot, metadata)
    return Inventory.AddItem(id, item, amount, metadata, slot) and true or false
end)
aliasExport('RemoveItem', function(id, item, amount, slot)
    return Inventory.RemoveItem(id, item, amount, nil, slot) and true or false
end)
aliasExport('GetItemBySlot', function(id, slot) return compatibilityItem(Inventory.GetSlot(id, slot)) end)
aliasExport('GetItemByName', function(id, item) return compatibilityItem(Inventory.GetSlotWithItem(id, item)) end)
aliasExport('GetItemsByName', function(id, item)
    local out = {}
    for i, row in pairs(Inventory.GetSlotsWithItem(id, item) or {}) do out[i] = compatibilityItem(row) end
    return out
end)
aliasExport('GetItemCount', function(id, item, metadata)
    if type(item) == 'table' then
        local count = 0
        for key, value in pairs(item) do
            local itemName = type(value) == 'string' and value or key
            count = count + (Inventory.GetItemCount(id, itemName, metadata) or 0)
        end
        return count
    end
    return Inventory.GetItemCount(id, item, metadata)
end)
aliasExport('HasItem', function(id, items, amount)
    amount = amount or 1
    local count = Inventory.Search(id, 'count', items)
    if type(count) == 'table' then
        for _, value in pairs(count) do if value < amount then return false end end
        return true
    end
    return (count or 0) >= amount
end)
aliasExport('CanAddItem', function(id, item, amount)
    return (Inventory.CanCarryAmount(id, item) or 0) >= amount
end)
aliasExport('ClearInventory', function(id, filter) return Inventory.Clear(id, filter) end)
aliasExport('GetInventory', function(id)
    local inventory = Inventory(id)
    if not inventory then return nil end

    local items = {}
    for slot, item in pairs(inventory.items) do items[slot] = compatibilityItem(item) end
    return {
        id = inventory.id,
        label = inventory.label,
        items = items,
        maxweight = inventory.maxWeight,
        slots = inventory.slots,
    }
end)

aliasExport('GetInventoryItems', function(id, owner)
    local inventory = Inventory(type(id) == 'string' and { id = id, owner = owner } or id)
    return inventory and inventory.items or {}
end)

aliasExport('RegisterStash', function(id, label, slots, maxWeight, owner, groups, coords)
    exports.w_inventory:RegisterStash(id, label, slots, maxWeight, owner, groups, coords)
    return true
end)
aliasExport('GetSlots', function(id)
    local inventory = Inventory(id)
    if not inventory then return 0, 0 end
    local used = 0
    for _ in pairs(inventory.items) do used = used + 1 end
    return used, math.max(0, inventory.slots - used)
end)
aliasExport('GetTotalWeight', function(items)
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
local function qbrSlotsByItem(items, itemName)
    if type(items) ~= 'table' then
        local inventory = Inventory(items)
        items = inventory and inventory.items or {}
    end

    local slots = {}
    itemName = tostring(itemName or ''):lower()
    for slot, item in pairs(items) do
        if type(item) == 'table' and tostring(item.name):lower() == itemName then
            slots[#slots + 1] = tonumber(item.slot) or tonumber(slot) or slot
        end
    end
    return slots
end
aliasExport('GetSlotsByItem', qbrSlotsByItem)
aliasExport('GetFirstSlotByItem', function(items, itemName)
    return qbrSlotsByItem(items, itemName)[1]
end)
aliasExport('UseItem', function(a, b, ...)
    if type(a) == 'string' then
        local callback = usableCallback(a)
        return callback and callback(b, ...)
    end

    return server.UseItem(a, type(b) == 'table' and b.name or b, b)
end)
aliasExport('CloseInventory', function(source)
    local inventory = Inventory(source)
    if inventory then inventory:closeInventory() end
end)
aliasExport('OpenInventoryById', function(source, target)
    return exports.w_inventory:forceOpenInventory(source, 'player', target)
end)
aliasExport('CreateInventory', function(id, config)
    config = config or {}
    exports.w_inventory:RegisterStash(id, config.label or id, config.slots or 50,
        config.maxweight or config.maxWeight or 100000, config.owner, config.groups or config.jobs)
    return true
end)
aliasExport('OpenInventory', function(source, id, data)
    if not id then
        TriggerClientEvent('w_inventory:openInventory', source)
        return true
    end

    local inventory = Inventory(id)
    if inventory then return exports.w_inventory:forceOpenInventory(source, inventory.type, inventory.id) end

    data = type(data) == 'table' and data or {}
    exports.w_inventory:RegisterStash(id, data.label or tostring(id), data.slots or 50,
        data.maxweight or data.maxWeight or 100000, data.owner, data.groups or data.jobs)
    return exports.w_inventory:forceOpenInventory(source, 'stash', id)
end)
aliasExport('DeleteInventory', function(id) Inventory.Remove(id); return true end)
aliasExport('RemoveInventory', function(id) Inventory.Remove(id); return true end)
aliasExport('SaveStash', function(id) if id then Inventory.Save(id) end; return true end)
aliasExport('ClearStash', function(id) Inventory.Clear(id); return true end)

aliasExport('SetInventory', function(source, items)
    return replaceInventory(source, items)
end)

aliasExport('SetItemData', function(source, itemName, key, value, slot)
    if not itemName or not key then return false end
    local item = slot and Inventory.GetSlot(source, tonumber(slot)) or Inventory.GetSlotWithItem(source, itemName)
    if not item or item.name:lower() ~= tostring(itemName):lower() then return false end

    if key == 'amount' or key == 'count' then
        local amount = tonumber(value)
        if not amount or amount < 0 or amount ~= amount then return false end
        amount = math.floor(amount)
        if amount > item.count then
            return Inventory.AddItem(source, item.name, amount - item.count, item.metadata, item.slot) == true
        elseif amount < item.count then
            return Inventory.RemoveItem(source, item.name, item.count - amount, item.metadata, item.slot) == true
        end
        return true
    end

    local metadata = table.clone(item.metadata or {})
    if key == 'info' or key == 'metadata' then
        metadata = type(value) == 'table' and table.clone(value) or {}
    else
        metadata[key] = value
    end
    return Inventory.SetMetadata(source, item.slot, metadata) == true
end)

aliasExport('GetItemWeight', function(itemName)
    local item = Items(itemName)
    return item and item.weight or nil
end)
aliasExport('GetFreeWeight', function(id)
    local inventory = Inventory(id)
    return inventory and math.max(0, inventory.maxWeight - inventory.weight) or 0
end)
aliasExport('ForceDropItem', function(source, itemName, amount, metadata)
    local item = Items(itemName)
    amount = math.floor(tonumber(amount) or 1)
    if not item or amount < 1 then return false end
    local ped = GetPlayerPed(source)
    if not ped or ped <= 0 then return false end
    return exports.w_inventory:CustomDrop('ui_drop', {
        { item.name, amount, type(metadata) == 'table' and metadata or {} }
    }, GetEntityCoords(ped), math.max(1, amount), item.weight * amount) or false
end)

aliasExport('CreateShop', function(shop)
    if not shop or not shop.name then return false end
    QBRShops[shop.name] = true
    local inventory = {}
    for _, item in pairs(shop.items or {}) do
        inventory[#inventory + 1] = {
            name = item.name,
            price = item.price,
            count = item.amount or item.count,
            metadata = item.info or item.metadata,
            slot = item.slot,
        }
    end
    exports.w_inventory:RegisterShop(shop.name, { name = shop.label or shop.name, inventory = inventory })
    return true
end)
aliasExport('DoesShopExist', function(name) return QBRShops[name] == true end)
aliasExport('OpenShop', function(source, name)
    TriggerClientEvent('qbr-inventory:client:OpenShop', source, name)
end)
