-- Deleting a character (w_core: staff in the admin panel, or the player in the character
-- selector). Everything w_inventory keeps under the citizen id goes, so the number can be given
-- to another character (a vanity id) with nothing of the old one left under it:
--   * its own stashes (`inventories` rows '<stash>:<id>', 'policestash_<id>', 'ambulancestash_<id>',
--     'stable_<stable>_<id>', '__w_confiscated:<id>') and the containers (satchels) kept in them or
--     carried in its bag are deleted; loaded copies are dropped unsaved so no save brings them back,
--     and so are the stash registrations named after the id;
--   * the cash behind them (each stash's ledger account and every moneybag claim in them or in the
--     bag) goes back to the reserve through w_centralbank FIRST: money is never destroyed;
--   * debt custody is the bank's property (an in-kind settlement of a loan): its rows and its escrow
--     stash move to the tombstone, never deleted. Delivered market receipts are the claims'
--     idempotency guard: kept, moved to the tombstone, so a replayed claim can never deliver twice;
--   * legacy `w_inventory` rows and rsg-weapons' `player_weapons` rows are deleted.
-- The bag itself is players.inventory: w_core deletes that row (it is only read here).
-- w_core calls this from a server thread after the player is offline and saved; a second run
-- finds nothing and answers true.
-- The end of the file follows w_core's other two events on a number: characterDeleted (what was
-- loaded again after this purge) and citizenIdChanged (a character moved to another number: what
-- is loaded follows it, or a late save would land on the number's next holder).
local Inventory = require 'modules.inventory.server'

local RESERVE, GOLD_RESERVE = 'central:reserve', 'central:gold'
-- the stash shapes of an id (w_core's registry, server/citizen.lua: inventories.identifier)
local OWN_SHAPES = { '^stable_[%w_]+_%s$', '^policestash_%s$', '^ambulancestash_%s$', '^[^:]+:%s$' }
local CUSTODY = '__w_debt:' -- server_debt.lua: '__w_debt:<id>:escrow:<case>'
-- the tables counted and emptied by id (the stashes are matched by shape instead)
local BY_ID = {
    { 'w_inventory_debt_custody', 'citizenid' }, { 'w_inventory_market_receipts', 'citizenid' },
    { 'w_inventory', 'owner' }, { 'player_weapons', 'citizenid' },
}
local purging = {}

local function esc(s) return (s:gsub('[%%%^%$%(%)%.%[%]%*%+%-%?]', '%%%0')) end

local function ownKey(key, cid)
    local e = esc(cid)
    for _, shape in ipairs(OWN_SHAPES) do
        -- a function replacement: the escaped id carries '%', which a replacement string reads
        if key:find((shape:gsub('%%s', function() return e end))) then return true end
    end
    return false
end

local function custodyKey(key, cid)
    local prefix = CUSTODY .. cid .. ':'
    return key:sub(1, #prefix) == prefix
end

--- The `inventories` key an inventory saves under (db.saveStash); nil for what never saves there.
local function persistKey(inv)
    if inv.player or inv.datastore or inv.type == 'player' or inv.type == 'glovebox' or inv.type == 'trunk' then return nil end
    local owner = inv.owner
    return owner and owner ~= '' and (tostring(inv.dbId) .. ':' .. tostring(owner)) or tostring(inv.dbId)
end

local function decodeRows(value)
    if type(value) == 'string' then
        local ok, rows = pcall(json.decode, value)
        value = ok and rows or nil
    end
    return type(value) == 'table' and value or {}
end

--- Moneybag claims and container ids in item rows (a native RSG row keeps its metadata in `info`).
local function scanRows(rows, claims, containers)
    for _, row in pairs(rows or {}) do
        local meta = type(row) == 'table' and (row.metadata or row.info)
        if type(meta) == 'table' then
            local claim = row.name == 'moneybag' and meta.economyClaim
            if type(claim) == 'string' and claim:match('^moneybag:%x+:cash$') then claims[claim] = true end
            -- only a generated container id ('ABC' .. os.time(), modules/items/server.lua) is
            -- followed: an item's metadata must never lead the purge to a shared stash
            local id = meta.container
            if containers and type(id) == 'string' and id:match('^%u%u%u%d+$') then containers[id] = true end
        end
    end
end

local function columns()
    local out = {}
    for _, r in ipairs(MySQL.query.await([[SELECT table_name AS t, column_name AS c FROM information_schema.columns
        WHERE table_schema = DATABASE() AND table_name IN ('players', 'inventories', 'cb_accounts',
        'w_inventory', 'w_inventory_market_receipts', 'w_inventory_debt_custody', 'player_weapons')]]) or {}) do
        out[r.t .. '.' .. r.c] = true
    end
    return out
end

--- Everything of `cid` in `inventories` and in memory: own = stash keys to delete, custody = keys to
--- move to the tombstone, inDb = the keys that have a row, loaded = inventories in memory,
--- claims = moneybag claims inside them or the bag. `keysOnly` skips reading the items.
local function collect(cid, has, keysOnly)
    local c = { own = {}, custody = {}, inDb = {}, loaded = {}, claims = {} }
    local containers, followed, byKey = {}, {}, {}
    for _, inv in pairs(Inventory.GetPersistenceInventories()) do
        if inv.player then
            if tostring(inv.owner) == cid then
                c.loaded[#c.loaded + 1] = inv
                scanRows(inv.items, c.claims, containers)
            end
        else
            local key = persistKey(inv)
            if key then byKey[key] = inv end
        end
    end
    local function take(key, kind)
        if c[kind][key] then return end
        c[kind][key] = true
        local inv = byKey[key]
        if inv then c.loaded[#c.loaded + 1] = inv end
        if kind ~= 'own' or keysOnly then return end
        if inv then scanRows(inv.items, c.claims, containers) end
        if has['inventories.items'] then
            scanRows(decodeRows(MySQL.scalar.await('SELECT items FROM inventories WHERE BINARY identifier = ?', { key })), c.claims, containers)
        end
    end
    local function sort(key, inDb)
        if custodyKey(key, cid) then take(key, 'custody') elseif ownKey(key, cid) then take(key, 'own') else return end
        if inDb then c.inDb[key] = true end
    end
    for key in pairs(byKey) do sort(key, false) end
    if has['inventories.identifier'] then
        for _, r in ipairs(MySQL.query.await('SELECT identifier FROM inventories WHERE INSTR(BINARY identifier, ?) > 0', { cid }) or {}) do
            sort(tostring(r.identifier), true)
        end
    end
    if keysOnly then return c end
    if has['players.inventory'] then
        scanRows(decodeRows(MySQL.scalar.await('SELECT inventory FROM players WHERE BINARY citizenid = ?', { cid })), c.claims, containers)
    end
    -- containers carried in the bag or kept in a stash are the character's too (nested ones as well)
    for _ = 1, 4 do
        local pending = {}
        for id in pairs(containers) do
            if not followed[id] then followed[id] = true pending[#pending + 1] = id end
        end
        if #pending == 0 then break end
        for _, id in ipairs(pending) do
            local inDb = has['inventories.identifier'] and MySQL.scalar.await('SELECT 1 FROM inventories WHERE BINARY identifier = ?', { id }) ~= nil
            if inDb or byKey[id] then
                take(id, 'own')
                if inDb then c.inDb[id] = true end
            end
        end
    end
    return c
end

local function counts(cid, has)
    local out, total = {}, 0
    for _, e in ipairs(BY_ID) do
        local n = 0
        if has[e[1] .. '.' .. e[2]] then
            n = tonumber(MySQL.scalar.await(('SELECT COUNT(*) FROM `%s` WHERE BINARY `%s` = ?'):format(e[1], e[2]), { cid })) or 0
        end
        out[e[1]], total = n, total + n
    end
    return out, total
end

--- Why the purge must wait (nil = it may run), and whether the owner's lock is only a held
--- recovery (a lost reply) that the purge settles and releases.
local function busy(cid, c)
    if server.nativeLoadingOwners[cid] then return 'inventory_busy' end
    if Inventory.GatheringState then
        local working, held = Inventory.GatheringState(cid)
        if working or held then return 'inventory_busy' end
    end
    local working, held = Inventory.MarketPurgeState(cid)
    if working then return 'inventory_busy' end
    held = held or (server.DebtCustodyHeld ~= nil and server.DebtCustodyHeld(cid))
    -- a lock nothing holds for recovery is an offline edit or a seizure running right now
    if server.nativeOfflineLocks[cid] and not held then return 'inventory_busy' end
    for _, inv in ipairs(c.loaded) do
        if inv.player and GetPlayerEndpoint(inv.id) then return 'online' end
        if type(inv.nativeTransfer) == 'thread' or Inventory.HasForeignSlotTransfer(inv) then return 'inventory_busy' end
    end
    return nil, held
end

--- The ledger moves that return the cash behind these stashes and claims to the reserve.
--- nil, reason while money may be there and the ledger cannot move it.
--- The ledger account is the record and the stash row only its copy: cash put in a police locker
--- just before a crash (no autosave yet) has a funded account and no row. So every ledger account
--- whose stash key is one of this id's shapes joins as well, whether a row or a copy exists or not.
local function cashMoves(c, has, cid)
    local seen = {}
    for key in pairs(c.own) do seen['inventory:stash:' .. key .. ':cash'] = true end
    for claim in pairs(c.claims) do seen[claim] = true end
    if has['cb_accounts.id'] then
        for _, r in ipairs(MySQL.query.await("SELECT id FROM cb_accounts WHERE id LIKE 'inventory:stash:%' AND INSTR(BINARY id, ?) > 0", { cid }) or {}) do
            local id = tostring(r.id)
            local key = id:match('^inventory:stash:(.+):[^:]+$')
            if key and ownKey(key, cid) then seen[id] = true end
        end
    end
    local ids = {}
    for id in pairs(seen) do ids[#ids + 1] = id end
    if #ids == 0 then return {} end
    table.sort(ids)
    local ready = false
    local okN, econName = pcall(function() return exports.w_lib:EconName() end)
    if okN and econName == 'w_centralbank' then
        local ok, value = pcall(function() return exports.w_lib:EconIsReady() end)
        ready = ok and value == true
    end
    if not ready then
        -- no ledger running: its table is the truth. Nothing funded, nothing to move; anything
        -- funded waits for the ledger (a deleted stash or moneybag would strand that money)
        if has['cb_accounts.id'] then
            for _, id in ipairs(ids) do
                if (tonumber(MySQL.scalar.await('SELECT balance FROM cb_accounts WHERE id = ?', { id })) or 0) > 0 then
                    return nil, 'economy_not_ready'
                end
            end
        end
        return {}
    end
    local moves = {}
    for _, id in ipairs(ids) do
        local ok, balance = pcall(function() return exports.w_lib:EconGetBalance(id) end)
        if not ok then return nil, 'economy_not_ready' end
        balance = tonumber(balance) -- nil: no such account
        if balance and balance > 0 then
            -- `expected` (cents): the ledger refuses the move if the balance changed since this read.
            -- A ':gold' account (the ledger's currency suffix) goes back to the gold reserve.
            local to = id:sub(-5) == ':gold' and GOLD_RESERVE or RESERVE
            moves[#moves + 1] = { from = id, to = to, amount = balance, expected = math.floor(balance * 100 + 0.5) }
        end
    end
    return moves
end

--- One ledger transaction for all of them. ok, USD cents, GOLD cents moved | reason.
--- A frozen account refuses the whole transaction ('account_frozen'). A stash account of the id's
--- own shapes is w_centralbank's too (CB.characterAccount): its purge, which w_core calls last,
--- sweeps it to the reserve even when frozen. So on that refusal those accounts are left to it and
--- only the rest moves here: moneybag claims and container accounts, which w_centralbank cannot
--- tell were the character's (a frozen one of those still refuses, before any row changes).
local function reclaim(moves, cid)
    if #moves == 0 then return true, 0, 0 end
    local function transfer(list)
        local ok, done, why = pcall(function()
            return exports.w_lib:EconTransferMany(list, 'Character deleted: stash cash returned to the reserve')
        end)
        if ok and done == true then return true end
        return false, tostring(why or done or 'transfer_failed')
    end
    local ok, why = transfer(moves)
    if not ok and why == 'account_frozen' then
        local rest = {}
        for _, m in ipairs(moves) do
            local key = m.from:match('^inventory:stash:(.+):[^:]+$')
            if not (key and ownKey(key, cid)) then rest[#rest + 1] = m end
        end
        if #rest < #moves then
            moves = rest
            if #moves == 0 then ok = true else ok, why = transfer(moves) end
        end
    end
    if not ok then return false, why end
    local usd, gold = 0, 0
    for _, m in ipairs(moves) do
        if m.to == GOLD_RESERVE then gold = gold + m.expected else usd = usd + m.expected end
    end
    return true, usd, gold
end

--- Delete / move to the tombstone every row `c` and the id tables hold, in one transaction.
local function sweep(cid, tomb, c, has)
    local n, total = counts(cid, has)
    local queries = {}
    if has['players.citizenid'] then
        -- the fence: every writer of this character's rows (a market delivery, a debt seizure)
        -- locks its players row first; taking it here waits out whichever one is committing
        queries[1] = { query = 'SELECT citizenid FROM players WHERE citizenid = ? FOR UPDATE', values = { cid } }
    end
    local fence = #queries
    -- every key, not only those seen in the table: one known from memory may have been saved since
    for key in pairs(c.own) do
        queries[#queries + 1] = { query = 'DELETE FROM inventories WHERE BINARY identifier = ?', values = { key } }
    end
    for key in pairs(c.custody) do
        queries[#queries + 1] = { query = 'UPDATE inventories SET identifier = ? WHERE BINARY identifier = ?',
                                  values = { CUSTODY .. tomb .. key:sub(#CUSTODY + #cid + 1), key } }
    end
    if n.w_inventory_debt_custody > 0 then
        queries[#queries + 1] = { query = 'UPDATE w_inventory_debt_custody SET citizenid = ? WHERE BINARY citizenid = ?', values = { tomb, cid } }
    end
    if n.w_inventory_market_receipts > 0 then
        -- the request is the canonical JSON market_claim.lua compares: its owner moves too
        queries[#queries + 1] = { query = 'UPDATE w_inventory_market_receipts SET citizenid = ?, request = REPLACE(request, ?, ?) WHERE BINARY citizenid = ?',
                                  values = { tomb, '"owner":' .. json.encode(cid), '"owner":' .. json.encode(tomb), cid } }
    end
    if n.w_inventory > 0 then queries[#queries + 1] = { query = 'DELETE FROM w_inventory WHERE BINARY owner = ?', values = { cid } } end
    if n.player_weapons > 0 then queries[#queries + 1] = { query = 'DELETE FROM player_weapons WHERE BINARY citizenid = ?', values = { cid } } end
    local done = { inventories = 0, inventories_custody = 0 }
    for key in pairs(c.inDb) do
        if c.own[key] then done.inventories = done.inventories + 1 else done.inventories_custody = done.inventories_custody + 1 end
    end
    for t, v in pairs(n) do done[t] = v end
    if #queries == fence then return true, done end
    local ok, committed = pcall(MySQL.transaction.await, queries)
    -- a lost acknowledgement is settled by the leftover check that follows, not guessed here
    return ok and committed == true, done, total
end

local function add(report, part)
    for k, v in pairs(part or {}) do report[k] = (report[k] or 0) + v end
end

--- What memory keeps for `cid` besides the loaded inventories, dropped once its rows are gone (the
--- end of the purge, and w_core's characterDeleted). Returns how many registrations went.
---   * the registrations named after the id ('policestash_<id>', 'stable_<key>_<id>'): a reader of
---     GetRegisteredStashes (stash admin, w_stables) would load the stash again, and that copy's
---     next save would write its row (and ledger account) back under the number;
---   * a recovery held for this character (market, debt custody): nothing is left to recover into.
--- `held`: the owner lock is a held recovery's (busy()), released with it.
local function forgetHeld(cid, held)
    local dropped = Inventory.ForgetRegisteredStashes(function(name)
        return type(name) == 'string' and not name:find(':', 1, true) and ownKey(name, cid)
    end)
    Inventory.ForgetMarketOwner(cid)
    if server.ForgetDebtCustody then server.ForgetDebtCustody(cid) end
    if held and not Inventory.MarketPurgeState(cid) then server.nativeOfflineLocks[cid] = nil end
    return dropped
end

local function run(cid, tomb)
    local has = columns()
    local c = collect(cid, has)
    local why, held = busy(cid, c)
    if why then return false, why end
    -- what is loaded reaches its row first: the custody stash keeps its content across the move
    -- (refused if it cannot), a deleted stash only so that a refusal below loses nothing
    local saved = false
    for _, inv in ipairs(c.loaded) do
        local key = persistKey(inv)
        if key and inv.changed and not inv.nativeTransfer then
            if Inventory.Save(inv) then saved = true elseif c.custody[key] then return false, 'save_failed' end
        end
    end
    if saved then c = collect(cid, has) end -- the rows (and the claims in them) as they are now
    local report = { memory = 0 }
    local usd, gold = 0, 0
    local function reclaimAll(col)
        local moves, err = cashMoves(col, has, cid)
        if not moves then return false, err end
        local ok, u, g = reclaim(moves, cid)
        if not ok then return false, u end
        usd, gold = usd + u, gold + g
        return true
    end
    local ok, err = reclaimAll(c)
    if not ok then return false, err end
    -- the loaded copies go now, unsaved; cash that reached them while the ledger was busy above
    -- is in their items (claims) or their accounts, so a second, usually empty, pass takes it
    for _, inv in ipairs(c.loaded) do
        if Inventory.Forget(inv) then report.memory = report.memory + 1 end
        scanRows(inv.items, c.claims)
    end
    ok, err = reclaimAll(c)
    if not ok then return false, err end
    local swept, done = sweep(cid, tomb, c, has)
    -- a save already on its way when the copies were dropped may land after the delete, and a
    -- stash reopened meanwhile is loaded again: one more pass, then anything left is an error
    for pass = 1, 2 do
        local rest = collect(cid, has, true)
        local _, left = counts(cid, has)
        left = left + #rest.loaded
        for _ in pairs(rest.inDb) do left = left + 1 end
        if left == 0 then break end
        if pass == 2 then return false, swept and 'leftovers' or 'database' end
        -- collected again WITH the items: a stash first seen here (saved or opened after the first
        -- collect) may hold moneybags, and its account cash; both go to the reserve before its
        -- rows go, exactly as in the first pass, or that money would be stranded under the number
        rest = collect(cid, has)
        for _, inv in ipairs(rest.loaded) do
            -- the character came back online meanwhile: its live bag is not ours to drop
            if inv.player and GetPlayerEndpoint(inv.id) then return false, 'online' end
            if Inventory.Forget(inv) then report.memory = report.memory + 1 end
            scanRows(inv.items, rest.claims)
        end
        ok, err = reclaimAll(rest)
        if not ok then return false, err end
        local again, redone = sweep(cid, tomb, rest, has)
        -- the first sweep's rows when it committed (this pass only removed copies of them),
        -- this pass's rows when the first did not
        if not swept then done = redone end
        swept = again
    end
    add(report, done)
    -- w_core's summary contract: money moved only as money = { USD = dollars, GOLD = gold }
    if usd > 0 or gold > 0 then
        report.money = {}
        if usd > 0 then report.money.USD = usd / 100 end
        if gold > 0 then report.money.GOLD = gold / 100 end
    end
    report.memory = report.memory + forgetHeld(cid, held)
    return true, report
end

exports('PurgeCharacter', function(citizenid, ctx)
    if GetInvokingResource() ~= 'w_core' then return false, 'forbidden' end
    local cid = tostring(citizenid or '')
    if cid == '' or #cid > 60 or not cid:match('^[%w_%-]+$') then return false, 'invalid_id' end
    ctx = type(ctx) == 'table' and ctx or {}
    local tomb = tostring(ctx.tombstone or ('deleted-%s-%d'):format(cid, math.floor(tonumber(ctx.at) or os.time())))
    -- it becomes part of a stash key ('__w_debt:<tombstone>:escrow:<case>') and a VARCHAR(64)
    if tomb == cid or #tomb > 64 or not tomb:match('^[%w_%-]+$') then return false, 'invalid_tombstone' end
    if purging[cid] then return false, 'inventory_busy' end
    purging[cid] = true
    local ok, done, detail = xpcall(run, debug.traceback, cid, tomb)
    purging[cid] = nil
    if not ok then
        print('[w_inventory] PurgeCharacter ' .. cid .. ': ' .. tostring(done))
        return false, 'purge_failed'
    end
    if done == true then
        lib.print.info(('[w_inventory] character %s purged by %s: %s'):format(cid, tostring(ctx.by or 'w_core'), json.encode(detail)))
    end
    return done, detail
end)

-- w_core's last step of a deletion, after every PurgeCharacter (this one included) and its own
-- transaction: a stash of the id loaded again in between (staff opened 'policestash_<id>') would
-- save its row back under the number, and a registration or a held state would outlive the
-- character. The memory the purge drops is dropped once more, unsaved; the rows are w_core's.
exports.w_lib:FwOnCharacterDeleted(function(citizenid)
    local cid = tostring(citizenid or '')
    if cid == '' then return end
    local loaded = {}
    for _, inv in pairs(Inventory.GetPersistenceInventories()) do
        if inv.player then
            -- a bag in play is never dropped (w_core does not delete a character in play)
            if tostring(inv.owner) == cid and not GetPlayerEndpoint(inv.id) then loaded[#loaded + 1] = inv end
        else
            local key = persistKey(inv)
            if key and (ownKey(key, cid) or custodyKey(key, cid)) then loaded[#loaded + 1] = inv end
        end
    end
    local dropped = 0
    for _, inv in ipairs(loaded) do
        if Inventory.Forget(inv) then dropped = dropped + 1 end
    end
    local _, held = Inventory.MarketPurgeState(cid)
    held = held or (server.DebtCustodyHeld ~= nil and server.DebtCustodyHeld(cid))
    dropped = dropped + forgetHeld(cid, held)
    if dropped > 0 then
        lib.print.info(('[w_inventory] character %s deleted: %d copy(ies) left in memory dropped'):format(cid, dropped))
    end
end)

-- ── moving a character to another number (w_core Reassign / TransferNumber) ──────────────
-- w_core renames the rows first (players.inventory travels with its row; the stash rows by the
-- shapes below, the same as its registry in server/citizen.lua), then fires citizenIdChanged(old,
-- new). What is loaded follows by the same rules: a copy left under the old number would save
-- the character's items back there, over whoever is given the number next (TransferNumber hands
-- it on at once), and that holder would be served this copy when he opens the stash. Both
-- characters were kicked (logout saves awaited); what can still be loaded is a stash someone
-- else has open, a bag a held recovery keeps, a registration, a held market / custody state.
-- Never yields: the two moves of a transfer (n -> fresh, then target -> n) fire back to back, and
-- the second must find the first done.

-- inventories.identifier in w_core's registry, in its order: the text before the id (captured)
-- and after it; each shape is applied in turn, the id replaced where it stands
local MOVES = {
    { '^(stable_[%w_]+_)', '$' }, { '^(policestash_)', '$' }, { '^(ambulancestash_)', '$' },
    { '^([^:]+:)', '$' }, { '^(' .. CUSTODY .. ')', '(:)' },
}

--- `key` with `old` rewritten to `new` as w_core rewrites its row; nil when it is not old's.
local function movedKey(key, old, new)
    local e, changed = esc(old), false
    for _, m in ipairs(MOVES) do
        local out, n = key:gsub(m[1] .. e .. m[2], function(head, tail) return head .. new .. (tail or '') end)
        if n > 0 then key, changed = out, true end
    end
    return changed and key or nil
end

--- The new id, owner and dbId of a loaded stash whose key became `to` (persistKey's
--- '<dbId>:<owner>' or '<dbId>'); nil when the two parts cannot be told apart.
local function movedStash(inv, to, old, new)
    local owner = inv.owner
    if not owner or owner == '' then return to, owner, to end
    local o = tostring(owner)
    if o == old and to == tostring(inv.dbId) .. ':' .. new then return to, new, inv.dbId end
    if to:sub(-(#o + 1)) == ':' .. o then return to, owner, to:sub(1, #to - #o - 1) end
    return nil
end

exports.w_lib:FwOnCitizenIdChanged(function(old, new)
    old, new = tostring(old or ''), tostring(new or '')
    if old == '' or new == '' or old == new then return end
    local bags, stashes = {}, {}
    for _, inv in pairs(Inventory.GetPersistenceInventories()) do
        if inv.player then
            if tostring(inv.owner) == old then bags[#bags + 1] = inv end
        else
            local key = persistKey(inv)
            local to = key and movedKey(key, old, new)
            if to then stashes[#stashes + 1] = { inv, to } end
        end
    end
    -- re-indexed after the traversal: Rekey adds keys to the table walked above
    local moved = 0
    for _, inv in ipairs(bags) do
        if Inventory.Rekey(inv, inv.id, new) then moved = moved + 1 end
    end
    for _, s in ipairs(stashes) do
        local inv, to = s[1], s[2]
        local id, owner, dbId = movedStash(inv, to, old, new)
        if id and Inventory.Rekey(inv, id, owner, dbId) then
            moved = moved + 1
        elseif Inventory.Forget(inv) then
            -- cannot follow: dropped unsaved, its rows already moved (a save would bring them back)
            print(('[w_inventory] %s -> %s: the loaded copy of %s could not follow and was dropped'):format(old, new, tostring(inv.id)))
        else
            print(('^1[w_inventory] %s -> %s: the loaded copy of %s is busy and stays under the old number^7'):format(old, new, tostring(inv.id)))
        end
    end
    moved = moved + Inventory.MoveRegisteredStashes(function(name)
        return type(name) == 'string' and not name:find(':', 1, true) and movedKey(name, old, new) or nil
    end, old, new)
    if Inventory.MoveMarketOwner(old, new) then moved = moved + 1 end
    if server.MoveDebtCustody and server.MoveDebtCustody(old, new) then moved = moved + 1 end
    if moved > 0 then
        lib.print.info(('[w_inventory] character %s moved to %s: %d loaded copy(ies) / registration(s) followed'):format(old, new, moved))
    end
end)
