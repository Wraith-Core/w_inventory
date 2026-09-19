local Inventory = require 'modules.inventory.server'
local Items = require 'modules.items.server'
local Ammo = {}
function Ammo.get(source)
    local inv = Inventory(source)
    if not inv then return nil end
    local result = {}
    for _, row in pairs(inv.items) do
        local definition = Items(row.name)
        if definition and definition.nativeGunbelt then
            result[definition.nativeGunbelt] = (result[definition.nativeGunbelt] or 0) + row.count
        end
    end
    return result
end
function Ammo.add(source, ammoType, amount)
    local name = '__vorp_belt_' .. tostring(ammoType):lower()
    local definition = Items(name)
    local inv = Inventory(source)
    amount = tonumber(amount)
    if not inv or not definition or not definition.nativeGunbelt or not amount or amount ~= amount or amount < 0 then return false end
    amount = math.floor(amount)
    local current = Inventory.GetItemCount(inv, name)
    local total = math.min(definition.gunbeltLimit, current + amount)
    if total > current and not Inventory.AddItem(inv, name, total - current) then return false end
    if not Inventory.Save(inv) then return false end
    TriggerClientEvent('vorpinventory:recammo', tonumber(source), { charidentifier = tonumber(inv.owner), ammo = Ammo.get(inv) }, false)
    return true
end
return Ammo
