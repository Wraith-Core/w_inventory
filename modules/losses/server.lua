-- ════════════════════════════════════════════════════════════════════════════
-- w_inventory · modules/losses/server.lua -- the loss journal (owner 2026-11-06)
--
--   Every item that leaves a character's bag is written to `w_losses`: what, how many, its metadata,
--   HOW it left (drop, give, taken by another player, police, used, crafted, admin, a resource ...),
--   who did it, where it went, where the player stood and when. Staff read it on the website (player
--   profile) and can give a row back once (w_connector op losses.restore -> RestoreLoss). Money is not
--   here: every cash/bank move is already in w_centralbank's cb_journal.
--
--   Callers inside w_inventory that go through Inventory.RemoveItem name the reason first:
--       Losses.reason('give', Losses.actor(toInventory), toInventory.id)
--       Inventory.RemoveItem(...)        -- takes (and clears) the reason at its first line
--   A RemoveItem without a reason is written as 'removed' by the invoking resource.
--   how = 'skip' writes nothing (ammo loaded into the player's own weapon stays his).
-- ════════════════════════════════════════════════════════════════════════════

local Losses = {}

local KEEP_DAYS = 60          -- rows older than this are deleted (once a day)
local FLUSH_MS = 2000         -- queued rows are written in one insert this often
local MAX_META = 8000         -- longer metadata is not stored (the row keeps name + count)
local NOT_ITEMS = { money = true, cash = true, gold = true } -- money lives in the ledger

local queue = {}
local ready = false
local pending = nil

--- The next RemoveItem's reason. by = { cid, name } (Losses.actor) or a resource name.
function Losses.reason(how, by, place)
    pending = { how = how, by = by, place = place }
end

--- RemoveItem's first line: the reason set just before it (or nil), cleared at once.
function Losses.take()
    local c = pending
    pending = nil
    return c
end

--- An inventory / server id -> { cid, name } of the character behind it.
function Losses.actor(x)
    if type(x) == 'table' then
        return { cid = x.owner and tostring(x.owner) or nil, name = x.label and tostring(x.label) or nil }
    end
    if type(x) == 'string' then return { name = x } end
    return nil
end

local function coordsOf(inv)
    if type(inv) ~= 'table' or not inv.player then return nil end
    local ok, c = pcall(function() return GetEntityCoords(GetPlayerPed(inv.id)) end)
    if ok and c then return ('%.1f,%.1f,%.1f'):format(c.x, c.y, c.z) end
    return nil
end

local function cut(s, n)
    if s == nil then return nil end
    s = tostring(s)
    return #s > n and s:sub(1, n) or s
end

--- One row. owner = a player inventory (online) or a citizenid string (offline edits).
function Losses.record(owner, name, count, metadata, how, by, place)
    if how == 'skip' then return end
    local cid = type(owner) == 'table' and (owner.player and owner.owner) or (type(owner) == 'string' and owner) or nil
    if not cid or cid == '' then return end
    count = math.floor(tonumber(count) or 0)
    if count < 1 or type(name) ~= 'string' or NOT_ITEMS[name] then return end
    local meta = nil
    if type(metadata) == 'table' and next(metadata) then
        local ok, enc = pcall(json.encode, metadata)
        if ok and type(enc) == 'string' and #enc <= MAX_META then meta = enc end
    end
    if type(by) == 'string' then by = { name = by } end
    -- no nil in a row: the insert's parameter list must stay a plain array ('' is read back as nil)
    queue[#queue + 1] = {
        tostring(cid), cut(name, 64), count, meta or '', cut(how or 'removed', 32),
        by and cut(by.cid, 64) or '', by and cut(by.name, 100) or '',
        cut(place, 100) or '', coordsOf(owner) or '',
    }
end

--- RemoveItem: what each slot held before the removal (player bags only).
function Losses.snapshot(inv, itemSlots, slot)
    if type(inv) ~= 'table' or not inv.player or type(itemSlots) ~= 'table' then return nil end
    local snap = {}
    local function keep(k)
        local row = inv.items[k]
        if row then snap[k] = { name = row.name, count = row.count, metadata = row.metadata } end
    end
    if slot and itemSlots[slot] then keep(slot) else for k in pairs(itemSlots) do keep(k) end end
    return snap
end

--- RemoveItem after a removal: one row per slot that went down.
function Losses.afterRemove(inv, snap, ctx, invoker)
    if not snap then return end
    local how = ctx and ctx.how or 'removed'
    if how == 'skip' then return end
    local by = ctx and ctx.by or (invoker and { name = invoker }) or nil
    local place = ctx and ctx.place or invoker
    for k, before in pairs(snap) do
        local after = inv.items[k]
        local left = (after and after.name == before.name) and after.count or 0
        local gone = before.count - left
        if gone > 0 then Losses.record(inv, before.name, gone, before.metadata, how, by, place) end
    end
end

-- ── the table, the writer, the clean-up ─────────────────────────────────────
CreateThread(function()
    MySQL.ready.await()
    MySQL.query.await([[CREATE TABLE IF NOT EXISTS w_losses (
        id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        citizenid VARCHAR(64) NOT NULL,
        item VARCHAR(64) NOT NULL,
        count INT NOT NULL,
        metadata TEXT NULL,
        how VARCHAR(32) NOT NULL,
        by_cid VARCHAR(64) NULL,
        by_name VARCHAR(100) NULL,
        place VARCHAR(100) NULL,
        coords VARCHAR(48) NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        restored_at TIMESTAMP NULL DEFAULT NULL,
        restored_by VARCHAR(100) NULL,
        KEY w_losses_cid (citizenid, id),
        KEY w_losses_at (created_at)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci]])
    ready = true
    while true do
        Wait(FLUSH_MS)
        if #queue > 0 then
            local rows = queue
            queue = {}
            local marks, values = {}, {}
            for i, r in ipairs(rows) do
                marks[i] = '(?,?,?,?,?,?,?,?,?)'
                for j = 1, 9 do values[#values + 1] = r[j] end
            end
            local ok, err = pcall(function()
                return MySQL.insert.await('INSERT INTO w_losses (citizenid,item,count,metadata,how,by_cid,by_name,place,coords) VALUES '
                    .. table.concat(marks, ','), values)
            end)
            if not ok then
                print(('^1[w_inventory] loss journal write failed (%d rows kept for the next try): %s^7'):format(#rows, tostring(err)))
                for _, r in ipairs(rows) do queue[#queue + 1] = r end
                if #queue > 5000 then for _ = 1, #queue - 5000 do table.remove(queue, 1) end end
            end
        end
    end
end)

CreateThread(function()
    while not ready do Wait(1000) end
    while true do
        pcall(function()
            MySQL.query.await('DELETE FROM w_losses WHERE created_at < (NOW() - INTERVAL ? DAY) LIMIT 50000', { KEEP_DAYS })
        end)
        Wait(24 * 3600 * 1000)
    end
end)

-- ── the website (w_connector only) ──────────────────────────────────────────
local CALLERS = { w_connector = true }
local function allowed() return CALLERS[GetInvokingResource() or ''] == true end

--- The server id of a character in play, or nil (the website shows whether a restore can work now).
exports('SourceOfCitizen', function(citizenid)
    if not allowed() then return nil end
    local Inventory = require 'modules.inventory.server'
    for _, v in pairs(Inventory.GetPersistenceInventories()) do
        if v.player and tostring(v.owner) == tostring(citizenid) then return v.id end
    end
    return nil
end)

--- The newest rows of a character: { id, item, count, metadata (table|nil), how, by_cid, by_name, place,
--- coords, created_at (unix), restored_at (unix|nil), restored_by }.
exports('ListLosses', function(citizenid, limit, beforeId)
    if not allowed() then return nil, 'forbidden' end
    if not ready then return nil, 'not_ready' end
    citizenid = tostring(citizenid or '')
    if citizenid == '' or #citizenid > 64 then return nil, 'invalid_character' end
    limit = math.max(1, math.min(200, math.floor(tonumber(limit) or 50)))
    local rows = MySQL.query.await(('SELECT id,item,count,metadata,how,by_cid,by_name,place,coords,UNIX_TIMESTAMP(created_at) AS at,'
        .. 'UNIX_TIMESTAMP(restored_at) AS restored_at,restored_by FROM w_losses WHERE citizenid=?%s ORDER BY id DESC LIMIT %d')
        :format(tonumber(beforeId) and ' AND id<?' or '', limit),
        tonumber(beforeId) and { citizenid, tonumber(beforeId) } or { citizenid }) or {}
    for _, r in ipairs(rows) do
        for _, k in ipairs({ 'metadata', 'by_cid', 'by_name', 'place', 'coords', 'restored_by' }) do
            if r[k] == '' then r[k] = nil end
        end
        if type(r.metadata) == 'string' then
            local ok, m = pcall(json.decode, r.metadata)
            r.metadata = ok and type(m) == 'table' and m or nil
        end
    end
    return rows
end)

--- Give one row back to its character (he must be in play: the item returns with its own metadata).
--- Once only: the row is claimed first and released again if the bag refuses it.
exports('RestoreLoss', function(id, by, citizenid)
    if not allowed() then return false, 'forbidden' end
    if not ready then return false, 'not_ready' end
    id = math.floor(tonumber(id) or 0)
    if id < 1 then return false, 'invalid_loss' end
    local row = MySQL.single.await('SELECT id,citizenid,item,count,metadata,restored_at FROM w_losses WHERE id=?', { id })
    if not row or (citizenid ~= nil and tostring(row.citizenid) ~= tostring(citizenid)) then return false, 'loss_not_found' end
    if row.restored_at then return false, 'already_restored' end
    local Inventory = require 'modules.inventory.server'
    local inv
    for _, v in pairs(Inventory.GetPersistenceInventories()) do
        if v.player and tostring(v.owner) == tostring(row.citizenid) then inv = v break end
    end
    if not inv then return false, 'player_offline' end
    local claimed = MySQL.update.await('UPDATE w_losses SET restored_at=NOW(), restored_by=? WHERE id=? AND restored_at IS NULL',
        { cut(by or 'website', 100), id })
    if claimed ~= 1 then return false, 'already_restored' end
    local meta = nil
    if type(row.metadata) == 'string' and row.metadata ~= '' then
        local ok, m = pcall(json.decode, row.metadata)
        meta = ok and type(m) == 'table' and m or nil
    end
    if meta then meta.used, meta.used2 = nil, nil end
    local ok, added, why = pcall(Inventory.AddItem, inv, row.item, row.count, meta)
    if not ok or not added then
        MySQL.update.await('UPDATE w_losses SET restored_at=NULL, restored_by=NULL WHERE id=?', { id })
        return false, (ok and why) and tostring(why) or 'cannot_carry'
    end
    TriggerClientEvent('w_inventory:notify', inv.id, { type = 'success', key = 'loss_restored', args = { row.count, { item = row.item } } })
    return true, { item = row.item, count = row.count, citizenid = row.citizenid }
end)

return Losses
