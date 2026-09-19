local Inventory = require 'modules.inventory.server'

local function openFrameworkInventory(source, inventoryType, inventoryId, data)
    data = type(data) == 'table' and data or {}
    inventoryType = tostring(inventoryType or ''):lower()

    if inventoryType == 'shop' then
        local shopId = inventoryId or ('shop_%s'):format(source)
        local items = {}

        for _, item in pairs(data.items or {}) do
            if item.name then
                items[#items + 1] = {
                    name = item.name,
                    price = item.price,
                    count = item.amount or item.count,
                    metadata = item.info or item.metadata,
                    slot = item.slot,
                }
            end
        end

        exports.w_inventory:RegisterShop(shopId, {
            name = data.label or shopId,
            inventory = items,
        })
        exports.w_inventory:forceOpenInventory(source, 'shop', shopId)
    elseif inventoryType == 'stash' then
        local stashId = inventoryId
        if not stashId then return end

        exports.w_inventory:RegisterStash(
            stashId,
            data.label or tostring(stashId),
            data.slots or 50,
            data.maxweight or data.maxWeight or 100000,
            data.owner,
            data.groups or data.jobs
        )
        exports.w_inventory:forceOpenInventory(source, 'stash', stashId)
    elseif inventoryType == 'otherplayer' or inventoryType == 'player' then
        local target = tonumber(inventoryId)
        if target then exports.w_inventory:forceOpenInventory(source, 'player', target) end
    end
end

RegisterNetEvent('inventory:server:OpenInventory', function(inventoryType, inventoryId, data)
    openFrameworkInventory(source, inventoryType, inventoryId, data)
end)

RegisterNetEvent('qbr-inventory:server:OpenInventory', function(inventoryType, inventoryId, data)
    openFrameworkInventory(source, inventoryType, inventoryId, data)
end)

RegisterNetEvent('inventory:server:CloseInventory', function()
    local playerInventory = Inventory(source)
    if playerInventory then playerInventory:closeInventory() end
end)

RegisterNetEvent('qbr-inventory:server:CloseInventory', function()
    local playerInventory = Inventory(source)
    if playerInventory then playerInventory:closeInventory() end
end)
