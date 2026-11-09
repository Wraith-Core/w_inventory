"""Execute the weapon module in Lua 5.4 against a deterministic RDR boundary.

The boundary models per-type reserve plus per-weapon clip, not game animation.
No server or database is used. Pass --baseline PATH to reproduce old failures.
"""
from pathlib import Path
import re
import sys
import unittest
from lupa.lua54 import LuaRuntime

ROOT = Path(__file__).resolve().parents[1]
if '--baseline' in sys.argv:
    index = sys.argv.index('--baseline')
    ROOT = Path(sys.argv[index + 1])
    del sys.argv[index:index + 2]


def joaat(value):
    result = 0
    for byte in value.lower().encode():
        result = (result + byte) & 0xffffffff
        result = (result + (result << 10)) & 0xffffffff
        result ^= result >> 6
    result = (result + (result << 3)) & 0xffffffff
    result ^= result >> 11
    result = (result + (result << 15)) & 0xffffffff
    return result - 0x100000000 if result >= 0x80000000 else result


def normalized(source):
    return re.sub(r'`([^`]+)`', lambda match: str(joaat(match[1])), source)


BOUNDARY = r'''
shared = { nativeRsgWeapons = false, isStoryOnlyWeapon = function() return false end }
cache = { ped = 1 }
Config = { Ammo = { ClipCap = 26, BowCap = 25 }, KeepHolsteredOnBody = true }
client = { weaponnotify = false }
PlayerData = { inventory = {}, source = 7 }
engine = { tick = 0, inventory = {}, pool = {}, clip = {}, binding = {}, drawn = 0,
    numeric = false, refuse = false, loaded = true, gun = false, calls = {}, sync = 0 }
Items = {}
local function bool(value)
    if engine.numeric then return value and 1 or 0 end
    return value
end
function GetHashKey(value) return joaat(value) end
function GetGameTimer() return engine.tick end
function Wait(ms) engine.tick = engine.tick + math.max(1, ms) end
function PlayerPedId() return 1 end
function PlayerId() return 1 end
function GetResourceState() return 'stopped' end
function IsWeaponAGun() return bool(engine.gun) end
function GetWeapontypeGroup() return 1 end
function HasPedGotWeapon(_, hash) return bool(engine.inventory[hash] == true) end
function GetAmmoInPedWeapon(_, hash)
    return (engine.pool[engine.binding[hash]] or 0) + (engine.clip[hash] or 0)
end
function SetAmmoTypeForPedWeapon(_, hash, ammo)
    engine.binding[hash] = ammo
    engine.calls[#engine.calls + 1] = 'bind'
end
function SetPedAmmoByType(_, ammo, amount)
    engine.pool[ammo] = amount
    engine.calls[#engine.calls + 1] = 'pool'
end
function GetPedAmmoByType(_, ammo)
    local amount = engine.pool[ammo] or 0
    for hash, clip in pairs(engine.clip) do
        if engine.binding[hash] == ammo then amount = amount + clip end
    end
    return amount
end
function SetAmmoInClip(_, hash, amount)
    engine.clip[hash] = amount
    engine.calls[#engine.calls + 1] = 'clip'
end
function GetAmmoInClip(_, hash) return true, engine.clip[hash] or 0 end
function GetMaxAmmoInClip() return true, 1 end
function SetCurrentPedWeapon(_, hash)
    engine.calls[#engine.calls + 1] = 'draw'
    if engine.inventory[hash] and (engine.binding[hash] == nil
        or GetPedAmmoByType(1, engine.binding[hash]) > 0) then engine.drawn = hash end
end
function GetCurrentPedWeapon() return bool(engine.drawn ~= 0), engine.drawn end
function GetCurrentPedWeaponEntityIndex() return engine.drawn ~= 0 and 22 or 0 end
function GetCurrentPedWeaponAmmoType(_, _) return engine.binding[engine.drawn] or 0 end
function DoesEntityExist(entity) return entity ~= 0 end
function RemoveAllPedWeapons()
    engine.inventory, engine.clip, engine.pool = {}, {}, {}
    engine.drawn = 0
end
function AddEventHandler() end
function TriggerEvent() end
function TriggerServerEvent() end
function warn() end
function locale(key) return key end
function exports() end
table.wipe = function(value) for key in pairs(value) do value[key] = nil end end
local noop = function() end
local Dual = { Slots = function() return {} end, State = function() return {} end,
    Equip = function() return false end, Count = function() return 0 end,
    HasHash = function() return false end, HasSlot = function() return false end,
    HandForSlot = function() return 0 end, Forget = noop }
lib = { load = function() return {} end, callback = { await = function(_, _, hands)
    engine.sync = engine.sync + 1
    return true, { hands = hands }
end } }
function require(name)
    if name == 'modules.items.client' then return Items end
    if name == 'modules.weapon.dualwield' then return Dual end
    if name == 'modules.utils.client' then return { Notify = noop } end
    error(name)
end
Citizen = { CreateThreadNow = noop, InvokeNative = function(hash, ...)
    local args = {...}
    if hash == 0xFF07CF465F48B830 then return bool(engine.loaded) end
    if hash == 0x72D4CB5DB927009C then engine.loaded = true; return end
    if hash == 0xB282DC6EBD803C75 then
        if not engine.refuse then engine.inventory[args[2]] = true end
        return
    end
    if hash == 0xB6CFEC32E3742779 then
        local ammo, amount = args[2], args[3]
        engine.pool[ammo] = math.max(0, (engine.pool[ammo] or 0) - amount)
    end
end }
'''


class WeaponDraw(unittest.TestCase):
    def setUp(self):
        self.lua = LuaRuntime(unpack_returned_tuples=True)
        self.lua.globals().joaat = joaat
        self.lua.execute(BOUNDARY)
        self.weapon = self.lua.execute(normalized((ROOT / 'modules/weapon/client.lua').read_text(encoding='utf-8')))
        self.lua.globals().Weapon = self.weapon

    def equip(self, name='WEAPON_RIFLE_SPRINGFIELD', ammo='AMMO_RIFLE', balance=12,
              exists=True, numeric=False, gun=True, refuse=False, special=None):
        self.lua.globals().name = name
        self.lua.globals().ammo = ammo
        self.lua.globals().balance = balance
        self.lua.globals().existing = exists
        self.lua.globals().numeric = numeric
        self.lua.globals().gun = gun
        self.lua.globals().refuse = refuse
        self.lua.globals().special = special
        self.lua.execute('''
            definition = { name = name, hash = joaat(name), weapon = true,
                ammoname = ammo and 'ammoitem' or nil, ammoType = ammo }
            item = { name = name, slot = 1, count = 1,
                metadata = { ammo = balance, durability = 100, specialAmmo = special } }
            Items[name] = definition
            PlayerData.inventory[1] = item
            engine.inventory[definition.hash] = existing
            engine.binding[definition.hash] = ammo and joaat(ammo) or nil
            engine.clip[definition.hash] = 0
            engine.numeric, engine.gun, engine.refuse = numeric, gun, refuse
            equipped, _, reason = Weapon.Equip(item, definition)
        ''')
        return self.lua.globals().engine, self.lua.globals().definition

    def test_holstered_rifle_gets_real_clip_before_draw(self):
        engine, definition = self.equip()
        self.assertEqual(engine.clip[definition.hash], 1)
        self.assertEqual(self.lua.eval('GetPedAmmoByType(1, joaat(ammo))'), 12)
        self.assertEqual(engine.drawn, definition.hash)
        calls = list(engine.calls.values())
        self.assertLess(calls.index('clip'), calls.index('draw'))

    def test_bow_is_ammo_weapon_and_draws_loaded(self):
        engine, definition = self.equip('WEAPON_BOW', 'AMMO_ARROW', 8, gun=False, numeric=True)
        self.assertFalse(self.lua.globals().item.melee)
        self.assertEqual(engine.clip[definition.hash], 8)
        self.assertEqual(engine.drawn, definition.hash)
        self.assertEqual(self.lua.eval('GetPedAmmoByType(1, joaat(ammo))'), 8)

    def test_fresh_weapon_accepts_numeric_native_booleans(self):
        engine, definition = self.equip(exists=False, numeric=True)
        self.assertTrue(engine.inventory[definition.hash])
        self.assertEqual(engine.drawn, definition.hash)

    def test_engine_refusal_does_not_commit_used_weapon(self):
        engine, _ = self.equip(exists=False, numeric=True, refuse=True)
        self.assertIsNone(self.lua.globals().equipped)
        self.assertEqual(self.lua.globals().reason, 'engine_failed')
        self.assertEqual(engine.sync, 0)

    def test_melee_is_not_a_firearm_with_boolean_native(self):
        engine, _ = self.equip('WEAPON_MELEE_KNIFE', None, None, gun=False)
        self.assertTrue(self.lua.globals().item.melee)
        self.assertIsNone(engine.pool[0])

    def test_extension_firearm_without_ammo_catalog_is_not_melee(self):
        self.equip('WEAPON_CUSTOM_TEST', None, None, gun=True)
        self.assertFalse(self.lua.globals().item.melee)

    def test_saved_special_ammo_is_rebound_on_existing_weapon(self):
        engine, definition = self.equip(special='AMMO_RIFLE_EXPRESS')
        self.assertEqual(engine.binding[definition.hash], joaat('AMMO_RIFLE_EXPRESS'))
        self.assertEqual(self.lua.eval("GetPedAmmoByType(1, joaat('AMMO_RIFLE_EXPRESS'))"), 12)

    def test_single_shot_consumes_one_round_without_refilling_clip(self):
        engine, definition = self.equip()
        self.lua.execute('''
            engine.clip[definition.hash] = 0
            engine.pool[joaat(ammo)] = 11
            result = Weapon.ObserveFiring(item, true, true)
        ''')
        self.assertEqual(self.lua.globals().item.metadata.ammo, 11)
        self.assertEqual(engine.clip[definition.hash], 0)
        self.assertEqual(self.lua.eval('GetPedAmmoByType(1, joaat(ammo))'), 11)

    def test_reconnect_is_configured_to_keep_empty_hands(self):
        lua = LuaRuntime()
        lua.execute(normalized((ROOT / 'config.lua').read_text(encoding='utf-8')))
        self.assertFalse(lua.globals().Config.RestoreUsedWeapons)

    def test_zero_balance_has_no_usable_ammo(self):
        engine, definition = self.equip(balance=0)
        self.assertFalse(self.weapon.HasUsableHeldAmmo(self.lua.globals().item))
        self.assertEqual(self.lua.eval('GetPedAmmoByType(1, joaat(ammo))'), 0)
        self.assertEqual(engine.clip[definition.hash], 0)

    def test_repeated_single_draw_does_not_add_rounds(self):
        self.equip()
        self.lua.execute('for i = 1, 8 do Weapon.Equip(item, definition) end')
        self.assertEqual(self.lua.globals().item.metadata.ammo, 12)
        self.assertEqual(self.lua.eval('GetPedAmmoByType(1, joaat(ammo))'), 12)

    def test_two_different_sidearms_keep_their_own_balances(self):
        self.equip('WEAPON_REVOLVER_CATTLEMAN', 'AMMO_REVOLVER', 3)
        self.lua.execute('''
            local name = 'WEAPON_REVOLVER_NAVY'
            Items[name] = {name=name, hash=joaat(name), weapon=true,
                ammoType='AMMO_REVOLVER', ammoname='ammoitem'}
            PlayerData.inventory[2] = {name=name, slot=2, metadata={ammo=8}}
            engine.binding[joaat(name)] = joaat(ammo)
            Weapon.DualWield.Slots = function() return {1, 2} end
            Weapon.ApplyAmmoSeparation(joaat(ammo))
        ''')
        self.assertEqual(self.lua.globals().item.metadata.ammo, 3)
        self.assertEqual(self.lua.globals().PlayerData.inventory[2].metadata.ammo, 8)
        self.assertEqual(self.lua.eval('GetPedAmmoByType(1, joaat(ammo))'), 9)
        self.assertEqual(self.lua.globals().engine.clip[joaat('WEAPON_REVOLVER_NAVY')], 6)

    def test_identical_sidearms_do_not_add_or_transfer_metadata(self):
        self.equip('WEAPON_REVOLVER_CATTLEMAN', 'AMMO_REVOLVER', 0)
        self.lua.execute('''
            PlayerData.inventory[2] = {name=name, slot=2, metadata={ammo=8}}
            Weapon.DualWield.Slots = function() return {1, 2} end
            for i=1,5 do Weapon.ApplyAmmoSeparation(joaat(ammo)) end
        ''')
        self.assertEqual(self.lua.globals().item.metadata.ammo, 0)
        self.assertEqual(self.lua.globals().PlayerData.inventory[2].metadata.ammo, 8)
        self.assertEqual(self.lua.eval('GetPedAmmoByType(1, joaat(ammo))'), 6)

    def test_character_login_clears_drawn_instances_and_used_flags_without_changing_ammo(self):
        self.equip()
        source = (ROOT / 'client.lua').read_text(encoding='utf-8')
        start = source.index('local function isUsageFlag(value)')
        end = source.index('\n---@param id number', start)
        chunk = source[start:end].replace('restoreGeneration += 1', 'restoreGeneration = restoreGeneration + 1')
        self.lua.execute('''
            restoreGeneration = 0
            Config.RestoreUsedWeapons = false
            item.metadata.used, item.metadata.used2 = true, true
            Weapon.ClearAll(nil, true)
        ''')
        self.lua.execute(normalized(chunk) + '\nrestoreUsedWeapons()')
        self.assertFalse(self.lua.globals().item.metadata.used)
        self.assertFalse(self.lua.globals().item.metadata.used2)
        self.assertEqual(self.lua.globals().item.metadata.ammo, 12)
        self.assertEqual(self.lua.globals().engine.drawn, 0)
        self.assertIsNone(self.lua.globals().engine.inventory[self.lua.globals().definition.hash])

    def test_redraw_rebinds_existing_slot_before_native_draw(self):
        self.equip('WEAPON_BOW', 'AMMO_ARROW', 8, gun=False)
        source = (ROOT / 'client.lua').read_text(encoding='utf-8')
        start = source.index('local function drawWeaponWheelLoadout(slots)')
        end = source.index("\nexports('holsterWeaponWheelLoadout'", start)
        self.lua.execute('''
            currentWeapon, heldWeapon, heldWeaponInfo = item, nil, nil
            NativeWeapons = nil
            runWheelLoadoutAction = function(action) return action() end
            sameWeaponSerial = function(a, b) return a == b end
            weaponSerial = function() return nil end
            wheelWeaponDrawn = function(_, hash) return engine.drawn == hash end
            Weapon.GetUsageState = function() return {count=1, hands={{slot=1, hash=item.hash}}} end
            engine.drawn = 0
            engine.pool[joaat(ammo)] = 0
            engine.clip[definition.hash] = 0
        ''')
        self.lua.execute(normalized(source[start:end]) + '\nredraw = drawWeaponWheelLoadout')
        result = self.lua.globals().redraw(self.lua.table_from([1]))
        self.assertTrue(result)
        self.assertEqual(self.lua.globals().engine.drawn, self.lua.globals().definition.hash)

    def execute_reload_tail(self, bow=False):
        name = 'WEAPON_BOW' if bow else 'WEAPON_RIFLE_SPRINGFIELD'
        ammo = 'AMMO_ARROW' if bow else 'AMMO_RIFLE'
        self.equip(name, ammo, 8 if bow else 12, gun=not bow)
        source = (ROOT / 'client.lua').read_text(encoding='utf-8')
        start = source.index('\t-- The weapon in hand: we put the rounds')
        end = source.index('\n\tif quiet then return end', start)
        self.lua.execute('''
            equippedWeapon, weaponSlot, weaponItem = item, 1, definition
            ammoItem = {ammoType=ammo}
            oldSpecial, special = nil, nil
            engine.pending, engine.reloads, engine.jumpBlocks = {}, 0, 0
            function SetTimeout(_, fn) engine.pending[#engine.pending+1] = fn end
            function DisableControlAction() engine.jumpBlocks = engine.jumpBlocks+1 end
            function N_0x79e1e511ff7efb13()
                engine.reloads = engine.reloads + 1
                -- The RDR boundary can move only reserve rounds that fit the clip.
                local cap = Weapon.ClipCapacity(definition)
                local clip = engine.clip[definition.hash] or 0
                local take = math.min(math.max(0, cap-clip), engine.pool[joaat(ammo)] or 0)
                engine.clip[definition.hash] = clip + take
                engine.pool[joaat(ammo)] = (engine.pool[joaat(ammo)] or 0) - take
            end
            -- A holstered weapon of the same family owns eight other rounds.
            PlayerData.inventory[2] = {name=name,slot=2,metadata={ammo=8}}
            engine.pool[joaat(ammo)] = 100
        ''')
        self.lua.execute(normalized(source[start:end]))

    def test_reload_cannot_borrow_holstered_weapon_balance_or_leave_late_writes(self):
        self.execute_reload_tail()
        engine = self.lua.globals().engine
        self.assertEqual(engine.reloads, 1)
        self.assertEqual(self.lua.eval('GetPedAmmoByType(1, joaat(ammo))'), 12)
        self.assertEqual(self.lua.globals().PlayerData.inventory[2].metadata.ammo, 8)
        self.assertEqual(len(engine.pending), 0)
        self.assertEqual(engine.jumpBlocks, 0)
        self.lua.execute('cache.ped=2; PlayerData.inventory={}; engine.calls={}')
        self.assertEqual(len(engine.calls), 0)

    def test_bow_reload_does_not_start_firearm_reload_or_block_jump(self):
        self.execute_reload_tail(bow=True)
        engine = self.lua.globals().engine
        self.assertEqual(engine.reloads, 0)
        self.assertEqual(engine.jumpBlocks, 0)
        self.assertEqual(len(engine.pending), 0)
        self.assertEqual(self.lua.eval('GetPedAmmoByType(1, joaat(ammo))'), 8)

    def test_burst_end_does_not_wait_for_duplicate_persist_or_block_next_shot(self):
        self.equip()
        source = (ROOT / 'client.lua').read_text(encoding='utf-8')
        start = source.index('\t\t\t\tif not invBusy and currentWeapon.timer ~= 0')
        end = source.index('\n\t\t\t\telseif currentWeapon.throwable then', start)
        self.lua.execute('''
            currentWeapon, invBusy, weaponAmmo = item, false, item.metadata.ammo
            currentWeapon.timer, engine.tick = 100, 500
            engine.pending = {}
            function CreateThread(fn)
                local thread = coroutine.create(fn)
                engine.pending[#engine.pending+1] = thread
                assert(coroutine.resume(thread))
            end
            function persistHeldAmmo(weapon)
                weapon._ammoPersistBusy = true
                coroutine.yield('server_reply_pending')
                weapon._ammoPersistBusy = nil
            end
        ''')
        self.lua.execute(normalized(source[start:end]) + '\nend')
        self.assertFalse(self.lua.globals().item._ammoPersistBusy)
        self.assertEqual(len(self.lua.globals().engine.pending), 0)
        self.lua.execute('Weapon.ObserveFiring(item,true,true)')
        self.assertEqual(self.lua.globals().item.metadata.ammo, 11)


if __name__ == '__main__':
    unittest.main()
