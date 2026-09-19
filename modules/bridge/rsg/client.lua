local RSGCore = exports['rsg-core']:GetCoreObject()
local Inventory = require 'modules.inventory.client'
local Weapon = require 'modules.weapon.client'
local Codec = require 'modules.mysql.rsg'
local Items = require 'modules.items.client'

RegisterNetEvent('RSGCore:Client:OnPlayerUnload', client.onLogout)

RegisterNetEvent('RSGCore:Player:SetPlayerData', function(data)
    if source == '' or not PlayerData.loaded or type(data) ~= 'table' then return end

    local metadata = data.metadata or {}
    local job = data.job or {}
    local gang = data.gang or {}
    local jobGrade = job.grade and (job.grade.level or job.grade) or 0
    local gangGrade = gang.grade and (gang.grade.level or gang.grade) or 0

    if (metadata.isdead or metadata.inlaststand) ~= PlayerData.dead then
        PlayerData.dead = metadata.isdead or metadata.inlaststand
        OnPlayerData('dead', PlayerData.dead)
    end

    local groups = PlayerData.groups

    if not groups[job.name or 'unemployed'] or not groups[gang.name or 'none']
        or groups[job.name or 'unemployed'] ~= jobGrade or groups[gang.name or 'none'] ~= gangGrade then
        PlayerData.groups = {
            [job.name or 'unemployed'] = tonumber(jobGrade) or 0,
            [gang.name or 'none'] = tonumber(gangGrade) or 0,
        }

        OnPlayerData('groups', PlayerData.groups)
    end

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
    for name, value in pairs(values) do
        -- values above 100 are taken as ten-thousandths (the scale some status resources send)
        if value > 100 or value < -100 then
            value = value * 0.0001
        end

        -- w_hud owns hunger/thirst on this stack (w_hud:server:setNeed takes the absolute value);
        -- the consumables:* events are the rsg-core resource's and only fire without w_hud.
        local hudOwnsNeeds = GetResourceState('w_hud') == 'started'
        if name == "hunger" then
            local newHunger = RSGCore.Functions.GetPlayerData().metadata.hunger + value
            if hudOwnsNeeds then
                TriggerServerEvent('w_hud:server:setNeed', 'hunger', newHunger)
            else
                TriggerServerEvent('consumables:server:addHunger', newHunger)
            end
        elseif name == "thirst" then
            local newThirst = RSGCore.Functions.GetPlayerData().metadata.thirst + value
            if hudOwnsNeeds then
                TriggerServerEvent('w_hud:server:setNeed', 'thirst', newThirst)
            else
                TriggerServerEvent('consumables:server:addThirst', newThirst)
            end
        elseif name == "stress" then
            if value > 0 then
                TriggerServerEvent('hud:server:GainStress', value)
            else
                value = math.abs(value)
                TriggerServerEvent('hud:server:RelieveStress', value)
            end
        end
    end
end

AddStateBagChangeHandler('inv_busy', ('player:%s'):format(cache.serverId), function(_, _, value)
    LocalPlayer.state:set('invBusy', value, false)
end)

local function export(exportName, func)
    AddEventHandler(('__cfx_export_%s_%s'):format(string.strsplit('.', exportName, 2)), function(setCB)
        setCB(func or function()
            error(("export '%s' is not supported when using w_inventory"):format(exportName))
        end)
    end)
end

export('rsg-inventory.HasItem', function(items, amount)
    amount = amount or 1

    if type(items) == 'table' then
        for key, value in pairs(items) do
            local itemName = type(key) == 'string' and key or value
            local needed = type(key) == 'string' and tonumber(value) or amount
            if Inventory.GetItemCount(itemName) < (needed or amount) then
                return false
            end
        end

        return true
    else
        return Inventory.GetItemCount(items) >= amount
    end
end)

RegisterNetEvent('rsg-inventory:client:OpenShop', function(name)
    exports.w_inventory:openInventory('shop', { type = name })
end)

export('rsg-inventory.GetItemByName', function(itemName)
    for _, item in pairs(PlayerData.inventory or {}) do
        if item and item.name:lower() == tostring(itemName):lower() then return Codec.toNativeItem(item, Items(item.name)) end
    end
end)

export('rsg-inventory.GetPlayerItems', function()
    local native = {}
    for slot, item in pairs(PlayerData.inventory or {}) do
        if item.name ~= 'money' and item.name ~= 'gold' then native[slot] = Codec.toNativeItem(item, Items(item.name)) end
    end
    return native
end)

export('rsg-inventory.closeInventory', function()
    return exports.w_inventory:closeInventory()
end)

RegisterNetEvent('rsg-inventory:client:closeinv', function()
    exports.w_inventory:closeInventory()
end)

RegisterNetEvent('rsg-inventory:client:CloseInventory', function()
    exports.w_inventory:closeInventory()
end)

RegisterNetEvent('inventory:client:CloseInventory', function()
    exports.w_inventory:closeInventory()
end)
