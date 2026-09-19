-- RSG native weapon engine facade. W never gives/removes GUIDs or rewrites ammo.
local Native = require 'modules.bridge.rsg.native_client'
local Weapon = { Native = Native, DualWield = {} }
local Dual = Weapon.DualWield
local function no() return false, 'native_weapon_engine' end
local function empty() return {} end
local function noop() end
function Weapon.Disarm() Native.clear(); return nil end
function Weapon.ClearAll(_, skipUsageSync)
    if not skipUsageSync then Native.clear() end
end
function Weapon.GetUsageState()
    local hands = {}
    for _, row in ipairs(Native.state().weapons) do
        if row.equipped then hands[#hands + 1] = row end
    end
    return { hands = hands, count = #hands }
end
function Weapon.HeldSlots()
    local slots = {}
    for _, row in ipairs(Weapon.GetUsageState().hands) do slots[#slots + 1] = row.slot end
    return slots
end
function Weapon.HeldSources() return {}, nil end
function Weapon.GetModifiers() return {}, 1 end
function Weapon.AmmoTypeForSlot() return 0 end
function Weapon.RemapUsageSlots() return nil end
Weapon.SyncUsage, Weapon.CaptureStatus, Weapon.EndInspection = noop, noop, noop
Weapon.ClearAmmoPool, Weapon.ClearLoadedAmmo, Weapon.ApplyDamageModifier = noop, noop, noop
Weapon.HeldSlotsForAmmo = empty
Weapon.Equip, Weapon.CanEquip, Weapon.ReassignAmmoPool, Weapon.ObserveFiring = no, no, no, no
Weapon.BeginInspection, Weapon.IsInspecting, Weapon.PlayCleaningInspection = no, no, no
Weapon.GetMaintenanceStatus, Weapon.ApplyMaintenanceState = no, no
Weapon.RefreshHeldAmmo, Weapon.HasUsableHeldAmmo = no, no
Dual.IsEnabled, Dual.IsCompatible, Dual.HasSlot, Dual.HasHash, Dual.Busy = no, no, no, no, no
Dual.EnsureOffhandHolster, Dual.RemapSlots, Dual.Forget = noop, noop, noop
Dual.State, Dual.Slots = empty, empty
Dual.Draw = Native.draw
Dual.HandForSlot, Dual.SlotForHand, Dual.Twin = noop, noop, noop
function Dual.Count() return 0 end
-- The active RSG engine skips dualwield.lua, so publish its read-only
-- equivalents here. Consumers keep calling the same w_lib inventory API.
local function usageState(dualOnly)
    local hands, primary = {}, nil
    for _, row in ipairs(Weapon.GetUsageState().hands) do
        if not dualOnly or row.dualCapable then
            local hand = tonumber(row.hand) or 0
            hands[#hands + 1] = {slot=row.slot, name=row.name, hash=row.hash,
                serial=row.serial, hand=hand, used=true, used2=false, drawn=row.drawn}
            if hand == 0 then primary = row.slot end
        end
    end
    table.sort(hands,function(a,b) if a.hand==b.hand then return a.slot<b.slot end;return a.hand<b.hand end)
    local hasSecondary=false
    for _, row in ipairs(hands) do if row.hand==1 then hasSecondary=true end end
    for _, row in ipairs(hands) do row.used2=hasSecondary and row.hand==0 end
    return {count=#hands,hands=hands,primary=primary}
end
exports('getDualWieldState',function() return usageState(true) end)
exports('getWeaponUsageState',function() return usageState(false) end)
return Weapon
