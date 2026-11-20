"""Run the inventory's real job exchange and persistent material catalog in Lua 5.4."""
import json
from pathlib import Path
import unittest

from lupa.lua54 import LuaRuntime

ROOT = Path(__file__).resolve().parents[1]


def source(path):
    return (ROOT / path).read_text(encoding="utf-8")


class JobGoldWash(unittest.TestCase):
    def setUp(self):
        self.vm = LuaRuntime(unpack_returned_tuples=True)
        self.vm.execute(r"""
            api = {}
            function exports(key, fn) api[key] = fn end
            caller = 'w_jobs'
            function GetInvokingResource() return caller end
            shared = {framework = 'rsg', backend = 'wcore'}
            lib = {print = {error = function() reported = true end}}
            server = {}
            function table.deepclone(row)
                if type(row) ~= 'table' then return row end
                local out = {}
                for k, v in pairs(row) do out[k] = table.deepclone(v) end
                return out
            end
            local function item(name, grams)
                return {name = name, nativeSource = 'wcore', stack = true, weight = grams}
            end
            Items = setmetatable({goldnugget = item('goldnugget', 2), washed_gold = item('washed_gold', 3)},
                {__call = function(t, key) return t[key] end})
            function Items.Metadata(_, _, meta, count)
                if pauseMetadata then coroutine.yield('metadata') end
                return meta, count
            end
            function metadataMatchForStack() return true end
            function GetMaxStack() return 100 end
            Inventory = setmetatable({}, {__call = function(_, src) return Inventories[src] end})
            function Inventory.SlotWeight(item, row) return item.weight * row.count end
            function Inventory.HasForeignSlotTransfer(inv) return inv.locked end
            function reset(stacks)
                bag = {id = 1, player = true, maxWeight = 100, slots = #stacks, items = {}, weight = 0,
                    syncSlotsWithClients = function(_, rows) published = rows end}
                Inventories = {[1] = bag}
                for i, n in ipairs(stacks) do
                    if n > 0 then
                        bag.items[i] = {name = 'goldnugget', slot = i, count = n, metadata = {}, weight = n*2}
                        bag.weight = bag.weight + n*2
                    end
                end
            end
        """)
        self.vm.globals().CartModule = self.vm.execute(source("modules/inventory/cart.lua"))
        self.vm.execute("""
            package.preload['modules.inventory.cart'] = function() return CartModule end
            package.preload['modules.inventory.market_claim'] = function() return function() end end
            package.preload['modules.inventory.gathering_award'] = function() return function() end end
        """)
        # Load the actual public export and its cart adapter. The unrelated portions
        # of the inventory server require Cfx-specific syntax and engine globals.
        server = source("modules/inventory/server.lua")
        self.vm.execute(server[server.index("local Cart = require 'modules.inventory.cart'"):
                               server.index("exports('CanCarryItems'")])

    def test_full_bag_exchanges_smallest_complete_stack_and_publishes_once(self):
        self.vm.execute("""
            reset({4, 2})
            assert(api.WashJobGold(1, 2))
            assert(bag.items[1].count == 4 and bag.items[1].name == 'goldnugget')
            assert(bag.items[2].name == 'washed_gold' and bag.items[2].count == 2)
            assert(#published == 1 and published[1].item.slot == 2)
            assert(bag.weight == 14 and bag.changed)
        """)

    def test_failures_leave_the_original_slots_and_weight_untouched(self):
        self.vm.execute("""
            reset({4})
            local slots = bag.items
            local function rejected(count, reason)
                local ok, why = api.WashJobGold(1, count)
                assert(not ok and why == reason, tostring(why))
                assert(bag.items == slots and slots[1].count == 4 and bag.weight == 8)
                assert(not bag.changed and not published)
            end
            caller = 'other'
            rejected(4, 'invalid_request')
            caller = 'w_jobs'
            rejected(0, 'invalid_count')
            rejected(5, 'not_enough_items')
            rejected(2, 'inventory_full')
            bag.maxWeight = 8
            rejected(4, 'weight_limit')
            bag.maxWeight, bag.locked = 20, true
            rejected(4, 'inventory_busy')
        """)

    def test_interleaved_metadata_hooks_cannot_spend_the_same_input_twice(self):
        self.vm.execute("""
            reset({3, 0})
            pauseMetadata = true
            local function wash() return coroutine.create(function() return api.WashJobGold(1, 3) end) end
            local a, b = wash(), wash()
            assert(select(2, coroutine.resume(a)) == 'metadata')
            assert(select(2, coroutine.resume(b)) == 'metadata')
            assert(select(2, coroutine.resume(a)) == true)
            local ok, granted, why = coroutine.resume(b)
            assert(ok and not granted and why == 'not_enough_items')
            assert(bag.items[1].name == 'washed_gold' and bag.items[1].count == 3 and not bag.items[2])
        """)

    def test_publication_failure_is_reported_as_committed(self):
        self.vm.execute("""
            reset({2})
            server.syncInventory = function() error('publication interrupted') end
            assert(api.WashJobGold(1, 2) and reported)
            assert(not api.WashJobGold(1, 2))
            assert(bag.items[1].name == 'washed_gold' and bag.items[1].count == 2)
        """)

    def test_reused_player_source_during_exchange_preserves_both_inventories(self):
        self.vm.execute("""
            reset({3})
            local prior = bag
            pauseMetadata = true
            local wash = coroutine.create(function() return api.WashJobGold(1, 3) end)
            assert(select(2, coroutine.resume(wash)) == 'metadata')
            reset({2})
            local ok, granted, why = coroutine.resume(wash)
            assert(ok and not granted and why == 'inventory_busy')
            assert(prior.items[1].count == 3 and prior.items[1].name == 'goldnugget')
            assert(bag.items[1].count == 2 and bag.items[1].name == 'goldnugget')
            assert(not prior.changed and not bag.changed and not published)
        """)


class GatheringMaterialCatalog(unittest.TestCase):
    def setUp(self):
        self.vm = LuaRuntime(unpack_returned_tuples=True)
        g = self.vm.globals()
        g.encode = lambda row: json.dumps(dict(row.items()), ensure_ascii=False)
        g.decode = lambda raw: self.vm.table_from(json.loads(raw))
        g.materialModule = self.vm.execute(source("modules/items/materials.lua"))
        g.catalogModule = self.vm.execute(source("modules/items/catalog.lua"))
        self.vm.execute(r"""
            api, callbacks, kv, events = {}, {}, {}, {}
            json = {encode = encode, decode = decode}
            shared = {backend = 'wcore', framework = 'rsg', info = function() end,
                resolveItemName = string.lower, isStoryOnlyWeapon = function() return false end,
                relocalizeItems = function() end, localizeItemData = function() end}
            lib = {load = function() return {} end, callback = {register = function(k, f) callbacks[k] = f end}}
            exports = setmetatable({
                ['rsg-core'] = {GetCoreObject = function()
                    return {Shared = {Items = {coal = {name = 'coal', type = 'item'}}, Weapons = {}}}
                end},
                w_lib = {
                    FwGetSharedItems = function() return {coal = {name = 'coal', type = 'item'}} end,
                    FwGetSharedWeapons = function() return {} end,
                },
            }, {__call = function(_, k, f) api[k] = f end})
            function TriggerEvent() end
            function TriggerClientEvent(...) events[#events + 1] = {...} end
            function CreateThread(f) f() end
            function GetGameTimer() return 1 end
            caller = 'w_jobs'
            function GetInvokingResource() return caller end
            function SetResourceKvp(k, v) if not failWrite then kv[k] = v end end
            function GetResourceKvpString(k) return kv[k] end
            function StartFindKvp(prefix)
                scan = {}
                for k in pairs(kv) do if k:sub(1, #prefix) == prefix then scan[#scan+1] = k end end
                return 1
            end
            function FindKvp() return table.remove(scan) end
            function EndFindKvp() end
            function require(k)
                if k == 'modules.items.materials' then return materialModule end
                if k == 'modules.items.catalog' then return catalogModule end
                return {}
            end
        """)
        self.boot()

    def boot(self):
        # This is the complete public lookup, item-catalog page and startup code,
        # up to the unrelated metadata helpers that require Cfx optional chaining.
        code = source("modules/items/server.lua").split("local function GenerateText", 1)[0]
        self.vm.execute("shared.ready = false")
        self.vm.execute(code)

    def test_registered_material_resolves_on_both_catalog_paths_across_restart(self):
        self.vm.execute("""
            local base = callbacks['w_inventory:itemCatalog'](1, 1).total
            assert(api.EnsureGatheringMaterial('opal', 'أوبال', 'Opal'))
            assert(api.EnsureGatheringMaterial('opal', 'أوبال', 'Opal'))
            local ok, why = api.EnsureGatheringMaterial('opal', 'مادة أخرى', 'Another material')
            assert(not ok and why == 'conflict')
            assert(api.Items('OPAL').label_ar == 'أوبال')
            assert(api.ItemList().opal.weight == 300 and api.ItemList().opal.stack)
            local page = callbacks['w_inventory:itemCatalog'](1, 1)
            assert(page.items.opal.label_en == 'Opal' and page.total == base + 1)
            assert(#events == 1 and events[1][1] == 'w_inventory:gatheringMaterial')
        """)
        self.vm.execute("kv['gathering:material:broken'] = 'unreadable'")
        self.boot()
        self.vm.execute("""
            local page = callbacks['w_inventory:itemCatalog'](1, 1)
            assert(api.Items('opal').label_en == 'Opal' and page.items.opal)
            assert(api.GatheringMaterials().opal.ar == 'أوبال' and not api.Items('broken'))
            assert(#events == 1)
        """)

    def test_invalid_untrusted_conflicting_or_failed_writes_do_not_publish(self):
        self.vm.execute("""
            local function rejected(k, ar, reason)
                local ok, why = api.EnsureGatheringMaterial(k, ar, 'Opal')
                assert(not ok and why == reason, tostring(why))
                assert(#events == 0 and not next(kv) and not api.Items('opal'))
            end
            caller = 'other'
            rejected('opal', 'أوبال', 'unavailable')
            caller = 'w_jobs'
            rejected('coal', 'أوبال', 'conflict')
            rejected('weapon_opal', 'أوبال', 'invalid')
            rejected('opal', '', 'invalid')
            failWrite = true
            rejected('opal', 'أوبال', 'unavailable')
            assert(api.Items('coal').name == 'coal')
        """)
