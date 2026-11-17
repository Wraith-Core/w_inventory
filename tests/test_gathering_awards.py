"""Exercise the Lua settlement service across fresh VMs, retries and ambiguous commits."""
import json
import sqlite3
import unittest
from pathlib import Path

from lupa.lua54 import LuaRuntime, lua_type

ROOT = Path(__file__).resolve().parents[1]


def unpack(value):
    if lua_type(value) != "table":
        return value
    keys = list(value.keys())
    if all(isinstance(k, int) for k in keys):
        return [unpack(value[i]) for i in range(1, len(keys) + 1)]
    return {k: unpack(v) for k, v in value.items()}


class Settlement(unittest.TestCase):
    def setUp(self):
        self.db = sqlite3.connect(":memory:", isolation_level=None)
        self.addCleanup(self.db.close)
        self.db.row_factory = sqlite3.Row
        self.db.executescript("""
            CREATE TABLE players(id INTEGER PRIMARY KEY, citizenid TEXT, inventory TEXT, w_gather_revision INTEGER DEFAULT 0);
            CREATE TABLE w_jobs_node_awards(node_key TEXT PRIMARY KEY, player_id INTEGER, track TEXT, xp INTEGER,
                items_json TEXT, pending_owner INTEGER UNIQUE, created_at INTEGER, completed_at INTEGER);
            CREATE TABLE w_jobs_progress(citizenid TEXT, track TEXT, xp INTEGER, runs INTEGER, last_at INTEGER, UNIQUE(citizenid,track));
            INSERT INTO players VALUES(19,'joe','[]',0);
        """)
        self.stop_commits = False
        self.drop_after_apply = False
        self.restart()

    def restart(self):
        self.vm = LuaRuntime(unpack_returned_tuples=True)
        env = self.vm.globals()
        env.query = self.query
        env.transaction = self.transaction
        env.json = self.vm.table(encode=lambda t: json.dumps(unpack(t)), decode=lambda s: self.table(json.loads(s)))
        env.codec = self.vm.execute((ROOT / "modules/mysql/rsg.lua").read_text(encoding="utf8"))
        env.cart = self.vm.execute((ROOT / "modules/inventory/cart.lua").read_text(encoding="utf8"))
        self.vm.execute("""
            local function copy(t)
                if type(t) ~= 'table' then return t end
                local out = {}; for k,v in pairs(t) do out[k]=copy(v) end; return out
            end
            package.preload['modules.mysql.rsg']=function() return codec end
            MySQL={single={await=function(sql,p) return query(sql,p)[1] end},startTransaction=function(f) return transaction(f) end}
            server={nativeOfflineLocks={}}
            shared={backend='wcore',framework='rsg',ready=true}
            lib={print={error=function(str) lastError=str end}}
            function TriggerEvent(...) end
            function CreateThread(f) end
            caller='w_jobs'
            function GetInvokingResource() return caller end
            function exports(_,fn) settle=fn end
            function Items(key)
                if key=='wood' or key=='ruby' then return {nativeSource='wcore',stack=true,name=key,weight=1} end
            end
            Inventory={HasForeignSlotTransfer=function() return false end,AwaitGatheringSaves=function() end}
            bag={id=11,ownerRow=19,owner='joe',player={},weight=0,items={},slots=4,maxWeight=2000,syncSlotsWithClients=function() notices=notices+1 end}
            function plan(inv,lines,_,maxLineCount)
                return cart.plan(inv, lines, {
                    item=Items, copy=copy, allowed=function() return true end, matches=function() return true end,
                    maxStack=function() return 10000 end, weight=function(_,r) return r.count end, weapon=function() return true end,
                    metadata=function(_,_,a,c) return a,c end,maxLineCount=maxLineCount,
                })
            end
            bags={[11]=bag}; notices=0
            function run(r) return settle(11,bag.owner,'w_jobs_',r) end
            function request(n)
                return {key='r123:1:1',track='woodcutting',xp=4,lines={{item='wood',count=n,label={ar='خشب',en='Wood'}}}}
            end
        """)
        self.vm.execute((ROOT / "modules/inventory/gathering_award.lua").read_text(encoding="utf8"))(
            env.Inventory, env.bags, env.Items, env.plan)
        row = self.db.execute("SELECT * FROM players WHERE id=19").fetchone()
        env.bag.owner = row["citizenid"]
        env.bag.gatherRevision = row["w_gather_revision"]
        env.restored = row["inventory"]
        self.vm.execute("for _,r in ipairs(codec.decode(restored)) do bag.items[r.slot]=r; bag.weight=bag.weight+r.count end")

    def table(self, data):
        return self.vm.table_from(data, recursive=True)

    def query(self, sql, params):
        if self.stop_commits:
            raise ValueError("disconnected")
        sql = sql.replace(" FOR UPDATE", "")
        if "ON DUPLICATE KEY" in sql:
            sql = sql.split(" ON DUPLICATE KEY", 1)[0] + (
                " ON CONFLICT(citizenid,track) DO UPDATE SET xp=MIN(2000000000,xp+excluded.xp),last_at=excluded.last_at")
        cursor = self.db.execute(sql, unpack(params))
        return self.table([dict(row) for row in cursor])

    def transaction(self, callback):
        if self.stop_commits:
            raise ValueError("temporarily disconnected")
        old = self.db.execute("SELECT w_gather_revision FROM players").fetchone()[0]
        self.db.execute("BEGIN")
        try:
            ok = callback(self.query)
            self.db.execute("COMMIT" if ok else "ROLLBACK")
        except BaseException:
            self.db.execute("ROLLBACK")
            raise
        new = self.db.execute("SELECT w_gather_revision FROM players").fetchone()[0]
        if self.drop_after_apply and new != old:
            self.drop_after_apply = False
            self.stop_commits = True
            raise ValueError("lost commit acknowledgement")
        return ok

    def test_a_completed_replay_keeps_consumed_goods_and_rejects_a_different_award(self):
        self.vm.execute("local ok,r=run(request(150)); assert(ok and r.totalXp==4 and bag.items[1].count==150)")
        self.vm.execute("bag.items={}; bag.weight=0; assert(run(request(150))); assert(not next(bag.items) and notices==1)")
        self.vm.execute("local ok,why=run(request(149)); assert(not ok and why=='conflict')")
        self.assertEqual(self.db.execute("SELECT SUM(xp) FROM w_jobs_progress").fetchone()[0], 4)

    def test_lost_ack_keeps_the_bag_fenced_and_same_key_different_reward_conflicts(self):
        self.drop_after_apply = True
        self.vm.execute("local ok,why=run(request(2)); assert(not ok and why=='pending' and bag.nativeTransfer and not next(bag.items))")
        self.stop_commits = False
        self.vm.execute("local ok,why=run(request(1)); assert(not ok and why=='conflict' and bag.items[1].count==2 and not bag.nativeTransfer)")
        self.vm.execute("assert(not server.nativeOfflineLocks.joe); assert(notices==1)")
        self.assertEqual(self.db.execute("SELECT SUM(xp) FROM w_jobs_progress").fetchone()[0], 4)
        self.restart()
        self.vm.execute("local ok,r=run(request(2)); assert(ok and r.totalXp==4 and bag.items[1].count==2 and notices==0)")

    def test_only_the_original_character_and_jobs_can_start_or_recover_a_node(self):
        self.vm.execute("""
            caller='w_store'; local ok,why=run(request(2)); assert(not ok and why=='forbidden')
            caller='w_jobs'; ok,why=settle(11,'another','w_jobs_',request(2)); assert(not ok and why=='no_character')
            ok,why=settle(11,'joe','bad prefix;',request(2)); assert(not ok and why=='invalid_request')
            shared.backend='vorp'; ok,why=run(request(2)); assert(not ok and why=='unavailable')
            shared.backend='wcore'; bag.maxWeight=1; ok,why=run(request(2)); assert(not ok and why=='inventory_full')
            assert(not server.nativeOfflineLocks.joe and not bag.nativeTransfer)
        """)
        self.assertEqual(self.db.execute("SELECT COUNT(*) FROM w_jobs_node_awards").fetchone()[0], 0)

    def test_pending_intent_after_restart_applies_at_new_character_number_once(self):
        self.db.execute("INSERT INTO w_jobs_node_awards VALUES('r123:1:1',19,'woodcutting',4,?,19,1,NULL)",
                        (json.dumps([{"item":"wood","count":2,"label":{"ar":"خشب","en":"Wood"}}]),))
        self.db.execute("UPDATE players SET citizenid='new'")
        self.restart()
        self.vm.execute("local ok,r=run(nil); assert(ok and r.totalXp==4 and r.lines[1].count==2); assert(bag.items[1].count==2)")
        self.vm.execute("local ok,r=run(nil); assert(ok and r==nil and notices==1)")
        self.assertEqual(self.db.execute("SELECT citizenid FROM w_jobs_progress").fetchone()[0], "new")

    def test_empty_roll_still_gives_xp_and_zero_xp_grants_only_the_items(self):
        self.vm.execute("""
            local r=request(1); r.lines={}; local ok,receipt=run(r)
            assert(ok and receipt.totalXp==4 and not next(bag.items))
            r=request(2); r.key='r123:1:2'; r.xp=0; ok,receipt=run(r)
            assert(ok and receipt.totalXp==4 and bag.items[1].count==2 and notices==1)
        """)

    def test_a_stale_live_generation_cannot_overwrite_the_native_bag_or_grant_xp(self):
        self.db.execute("UPDATE players SET w_gather_revision=7")
        self.vm.execute("local ok,why=run(request(1)); assert(not ok and why=='inventory_busy' and not next(bag.items))")
        self.assertEqual(self.db.execute("SELECT COUNT(*) FROM w_jobs_progress").fetchone()[0], 0)

    def test_new_character_waits_for_the_core_to_supply_a_stable_row_id(self):
        self.vm.execute("""
            bag.ownerRow=nil
            Inventory.GatheringOwnerRow=function() return nil end
            local ok,why=run(request(1)); assert(not ok and why=='no_character')
            Inventory.GatheringOwnerRow=function(inv) inv.ownerRow=19; return inv.ownerRow end
            ok=run(request(1)); assert(ok and bag.items[1].count==1)
        """)


if __name__ == "__main__":
    unittest.main()
