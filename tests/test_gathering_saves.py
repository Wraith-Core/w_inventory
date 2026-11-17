"""Run the native bag save, load and disconnect boundaries across a gathering commit."""
from pathlib import Path
import re
import unittest

from lupa.lua54 import LuaRuntime


ROOT = Path(__file__).resolve().parents[1]


def section(file, start, end):
    source = (ROOT / file).read_text(encoding="utf-8")
    return source[source.index(start):source.index(end, source.index(start))]


class GatheringSaves(unittest.TestCase):
    def setUp(self):
        self.vm = LuaRuntime(unpack_returned_tuples=True)
        self.vm.execute("""
            shared = { backend = 'wcore', framework = 'rsg' }
            Inventories, db, writes = {}, {}, {}
            server = {nativeOfflineLocks={}, nativeLoadingOwners={}}
            bag = {id=7, owner='C', ownerRow=42, player={}, items={value='before'}, changed=true, gatherRevision=0}
            Inventories[7] = bag
            Inventory = setmetatable({}, {__call = function(_, key)
                local inv = type(key)=='table' and key or Inventories[key]
                while inv and inv.nativeTransfer and inv.nativeTransfer ~= coroutine.running() do Wait(0) end
                return inv
            end})
            function Inventory.GetPersistenceInventories() return Inventories end
            function Wait() coroutine.yield('wait') end
            function persistentRows(inv) return inv.items.value end
            function warn() end
            function exports() end
            function step(thread)
                local ok, result = coroutine.resume(thread)
                assert(ok, tostring(result))
                return result
            end
            function db.savePlayer(owner, contents, live, row, revision)
                assert(owner=='C' and row==42)
                if pauseWrite then coroutine.yield('sql') end
                writes[#writes+1]={value=contents, revision=revision}
                if failWrite then error('connection lost') end
                return true
            end
        """)
        inv = "modules/inventory/server.lua"
        self.vm.execute(section(inv, "function Inventory.AwaitGatheringSaves(", "---@param inv inventory\n---@param invType"))
        self.vm.execute(section(inv, "local function removeInventory(", "exports('RemoveInventory'"))

    def test_grant_drains_prior_autosave_and_later_save_uses_committed_epoch(self):
        self.vm.execute("""
            pauseWrite = true
            local autosave = coroutine.create(function() assert(Inventory.Save(7)) end)
            assert(step(autosave)=='sql')
            local award = coroutine.create(function()
                bag.nativeTransfer = coroutine.running()
                Inventory.AwaitGatheringSaves(bag)
                bag.items, bag.gatherRevision = {value='earned'}, 1
                bag.nativeTransfer = nil
            end)
            assert(step(award)=='wait')
            local following = coroutine.create(function() assert(Inventory.Save(7)) end)
            assert(step(following)=='wait')
            pauseWrite = false
            step(autosave); step(award); step(following)
            assert(#writes==2 and writes[1].value=='before' and writes[1].revision==0)
            assert(writes[2].value=='earned' and writes[2].revision==1)
            failWrite = true
            assert(not Inventory.Save(7) and bag.pendingPlayerWrites==0 and bag.changed)
        """)

    def test_disconnect_keeps_exclusive_ownership_through_last_write(self):
        self.vm.execute("""
            activeIdentifiers = {C=7}
            bag.openedBy = {}
            pauseWrite=true
            local drop = coroutine.create(function() assert(Inventory.Remove(bag)) end)
            assert(step(drop)=='sql')
            assert(bag.nativeTransfer==drop and Inventories[7]==bag)
            pauseWrite=false; step(drop)
            assert(Inventories[7]==nil and bag.nativeTransfer==nil)
            local replacement = { id=7, player={}, items={} }
            Inventories[7] = replacement
            assert(Inventory.Remove(bag) and Inventories[7]==replacement)
        """)

    def test_offline_core_object_cannot_overwrite_new_epoch_or_a_connected_bag(self):
        self.vm.execute("""
            function normalizeOfflineItems(rows) return rows end
            json={encode=function() return 'edited' end}
            offline = {id=42,citizenid='C',items={ [1]={name='wood',count=1,slot=1,metadata={}} }}
            function db.savePlayer(_, value, _, row, rev)
                assert(server.nativeOfflineLocks.C and row==42 and value=='edited')
                return rev==1
            end
        """ + section("modules/bridge/rsg/server.lua", "local function saveOfflineItems(", "local function setCoreItems(")
                        + "saveOffline = saveOfflineItems")
        self.vm.execute("""
            assert(not saveOffline(offline)) -- the live bag owns the character
            Inventories[7] = nil
            assert(not saveOffline(offline)) -- object opened before the award
            assert(server.nativeOfflineLocks.C==nil)
            offline.w_gather_revision=1
            assert(saveOffline(offline))
            server.nativeLoadingOwners.C=true
            assert(not saveOffline(offline))
        """)

    def test_cold_load_waits_for_commit_and_stale_save_is_refused(self):
        self.vm.execute("""
            function awaitDatabase() end
            nativeRsg = {encode=function(v) return v end, decode=function(v) return v end}
            Query = { UPDATE_GATHERING_BAG='guarded update' }
            local committed = {id=42,inventory='before',w_gather_revision=0}
            MySQL = {
                startTransaction = function(f)
                    return f(function(sql)
                        assert(sql:find('FOR UPDATE',1,true))
                        if writerLocked then coroutine.yield('writer') end
                        return {committed}
                    end)
                end,
                update = {await=function(sql, args)
                    assert(sql == 'guarded update' and args[2]=='C' and args[3]==42)
                    if args[5]~=committed.w_gather_revision or args[1]==committed.inventory then return 0 end
                    committed.inventory=args[1]; return 1
                end},
                scalar = {await=function(sql, args)
                    assert(sql:find('w_gather_revision',1,true))
                    if args[4]==committed.w_gather_revision and args[5]==committed.inventory then return 1 end
                end}
            }
            function commitPriorResource()
                committed.inventory, committed.w_gather_revision, writerLocked = 'earned', 1, false
            end
        """ + section("modules/mysql/server.lua", "function db.loadGatheringBag(", "--- players.id of a character"))
        self.vm.execute("""
            writerLocked=true
            local login = coroutine.create(function()
                local data, id, rev = db.loadGatheringBag('C')
                assert(data=='earned' and id==42 and rev==1)
            end)
            assert(step(login)=='writer')
            commitPriorResource(); step(login)
            assert(not db.savePlayer('C','before',nil,42,0))
            assert(db.savePlayer('C','earned',nil,42,1))
            assert(db.savePlayer('C','earned plus later material',nil,42,1))
        """)

    def test_first_login_only_adopts_its_own_live_character_generation(self):
        self.vm.execute("""
            bag.ownerRow=nil
            local player = {PlayerData={id=51,citizenid='other',source=7}}
            server.GetPlayerFromId = function() return player end
            assert(not Inventory.GatheringOwnerRow(bag))
            player.PlayerData.citizenid='C'; player.PlayerData.id=nil
            assert(not Inventory.GatheringOwnerRow(bag))
            player.PlayerData.id=42
            assert(Inventory.GatheringOwnerRow(bag)==42 and bag.ownerRow==42)
        """)

    def test_supplied_bootstrap_items_cannot_replace_a_committed_award(self):
        load = section("server.lua", "    local ownerRow, gatherRevision", "-- story-only weapons (")
        self.vm.execute("function bootstrap(player, data)\n" + load + "\nreturn data, ownerRow, gatherRevision end")
        self.vm.execute("""
            local player, supplied, committed = {identifier='C'}, {}, {}
            local revision=2
            db.loadGatheringBag=function() return committed,42,revision end
            assert(bootstrap(player, supplied)==committed)
            revision=0
            assert(bootstrap(player, supplied)==supplied)
            assert(bootstrap(player, nil)==committed)
        """)

    def test_yielded_item_hook_cannot_mutate_locked_or_replaced_slots(self):
        add = section("modules/inventory/server.lua", "function Inventory.AddItem(", "exports('AddItem'")
        # Expand the Cfx-only expressions for stock Lua 5.4.
        add = add.replace("inv?.slots", "(inv and inv.slots)")
        add = re.sub(r"(\w+) ([+\-])= ", r"\1 = \1 \2 ", add)
        self.vm.execute(add)
        self.vm.execute("""
            bag.slots = 5
            function shared.isStoryOnlyWeapon() return false end
            function assertMetadata(m) return m or {} end
            table.clone = function() return {} end
            function GetMaxStack() return 100 end
            Items = {Metadata=function() coroutine.yield('metadata'); return {}, 1 end}
            local item = {name='wood', nativeSource='wcore', stack=true}
            for _, state in pairs({'held', 'completed'}) do
                local t=coroutine.create(function()
                    local ok, why=Inventory.AddItem(bag, item, 1, {}, 1)
                    assert(not ok and why=='inventory_busy')
                end)
                assert(step(t)=='metadata')
                if state=='held' then bag.nativeTransfer='gathering_unknown:key' else bag.items={} end
                step(t)
                bag.nativeTransfer=nil
                assert(not bag.items[1])
            end
        """)
