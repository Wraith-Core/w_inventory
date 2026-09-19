local Inventory = require 'modules.inventory.client'
local Weapon = require 'modules.weapon.client'

local function getPlayerData()
    local ok, data = pcall(function() return exports['qbr-core']:GetPlayerData() end)
    return ok and data or {}
end

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    client.onLogout()
    TriggerServerEvent('w_inventory:qbr:playerLogout')
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
    if source == '' or not PlayerData.loaded or type(data) ~= 'table' then return end

    local metadata = data.metadata or {}
    local dead = metadata.isdead == true or metadata.inlaststand == true

    if dead ~= PlayerData.dead then
        PlayerData.dead = dead
        OnPlayerData('dead', dead)
    end

    local job = data.job or {}
    local gang = data.gang or {}
    local groups = {
        [job.name or 'unemployed'] = job.grade and (job.grade.level or job.grade) or 0,
        [gang.name or 'none'] = gang.grade and (gang.grade.level or gang.grade) or 0,
    }

    PlayerData.groups = groups
    OnPlayerData('groups', groups)

    if metadata.ishandcuffed then
        PlayerData.cuffed = true
        LocalPlayer.state:set('invBusy', true, false)
        Weapon.Disarm()
    elseif PlayerData.cuffed then
        PlayerData.cuffed = false
        LocalPlayer.state:set('invBusy', false, false)
    end
end)

---@diagnostic disable-next-line: duplicate-set-field
function client.setPlayerStatus(values)
    local metadata = getPlayerData().metadata or {}

    for name, value in pairs(values) do
        if value > 100 or value < -100 then value = value * 0.0001 end

        if name == 'hunger' or name == 'thirst' or name == 'stress' then
            local nextValue = math.max(0, math.min(100, (tonumber(metadata[name]) or 0) + value))
            TriggerServerEvent('QBCore:Server:SetMetaData', name, nextValue)
        end
    end
end

AddStateBagChangeHandler('inv_busy', ('player:%s'):format(cache.serverId), function(_, _, value)
    LocalPlayer.state:set('invBusy', value, false)
end)

local function aliasExport(name, callback)
    AddEventHandler(('__cfx_export_qbr-inventory_%s'):format(name), function(setCallback)
        setCallback(callback)
    end)
end

aliasExport('HasItem', function(items, amount)
    amount = amount or 1

    if type(items) == 'table' then
        for key, value in pairs(items) do
            local itemName = type(key) == 'string' and key or value
            local needed = type(key) == 'string' and value or amount
            if Inventory.GetItemCount(itemName) < needed then return false end
        end
        return true
    end

    return Inventory.GetItemCount(items) >= amount
end)

aliasExport('GetItemByName', function(itemName)
    for _, item in pairs(PlayerData.inventory or {}) do
        if item and item.name == itemName then return item end
    end
end)

aliasExport('GetPlayerItems', function()
    return PlayerData.inventory or {}
end)

aliasExport('closeInventory', function()
    return exports.w_inventory:closeInventory()
end)

RegisterNetEvent('qbr-inventory:client:OpenShop', function(name)
    exports.w_inventory:openInventory('shop', { type = name })
end)

RegisterNetEvent('qbr-inventory:client:closeinv', function()
    exports.w_inventory:closeInventory()
end)

RegisterNetEvent('qbr-inventory:client:CloseInventory', function()
    exports.w_inventory:closeInventory()
end)

RegisterNetEvent('inventory:client:CloseInventory', function()
    exports.w_inventory:closeInventory()
end)
