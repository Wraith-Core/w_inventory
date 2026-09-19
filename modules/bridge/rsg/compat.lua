local Inventory = require 'modules.inventory.server'

-- Compatibility events used by RSG resources that still target the native bag.
local function openFrameworkInventory(source, inventoryType, inventoryId)
    inventoryType=tostring(inventoryType or ''):lower()
    if type(inventoryId)~='string' and type(inventoryId)~='number' then return end
    -- Network callers request an existing inventory. Definitions, prices and forced access belong to server exports.
    if inventoryType=='shop' then
        TriggerClientEvent('w_inventory:openInventory',source,'shop',{type=inventoryId})
    elseif inventoryType=='stash' then
        TriggerClientEvent('w_inventory:openInventory',source,'stash',inventoryId)
    elseif inventoryType=='otherplayer' or inventoryType=='player' then
        local target=tonumber(inventoryId)
        if target then TriggerClientEvent('w_inventory:openInventory',source,'player',target) end
    end
end

local function closeFrameworkInventory(source)
    local playerInventory = Inventory(source)
    if playerInventory then playerInventory:closeInventory() end
end

RegisterNetEvent('inventory:server:OpenInventory', function(inventoryType, inventoryId, data)
    openFrameworkInventory(source, inventoryType, inventoryId, data)
end)

RegisterNetEvent('rsg-inventory:server:OpenInventory', function(inventoryType, inventoryId, data)
    openFrameworkInventory(source, inventoryType, inventoryId, data)
end)

RegisterNetEvent('inventory:server:CloseInventory', function()
    closeFrameworkInventory(source)
end)

RegisterNetEvent('rsg-inventory:server:CloseInventory', function()
    closeFrameworkInventory(source)
end)
