-- Build a complete replacement first. There is no intermediate state with a
-- missing box or free rounds, and a full bag rejects the entire conversion.
local Exchange = {}
local function integer(n) return type(n) == 'number' and n == n and n > 0 and n < 100000000 and n % 1 == 0 end
local function copy(row)
    local out = {}
    for k, v in pairs(row) do out[k] = v end
    return out
end

function Exchange.plan(inv, slot, input, output, outputMetadata, packing, size, weight, maxStack, matches)
    local source = inv.items[slot]
    if not source or not integer(source.count) or not integer(size) or not output.stack then return nil, 'invalid' end
    local removed, added
    if packing then
        added = math.floor(source.count / size)
        if added < 1 then return nil, 'need', size end
        removed = added * size
    else removed, added = source.count, source.count * size end
    if not integer(added) then return nil, 'invalid' end
    local nextItems, changes = copy(inv.items), { [slot] = true }
    local after = source.count - removed
    local totalWeight = inv.weight - source.weight
    if after == 0 then nextItems[slot] = nil
    else
        local remainder = copy(source)
        remainder.count = after
        remainder.weight = weight(input, remainder)
        nextItems[slot] = remainder
        totalWeight = totalWeight + remainder.weight
    end
    local remaining = added
    local function put(index, row)
        local room = maxStack(output.name) - (row and row.count or 0)
        local count = math.min(remaining, room)
        if count <= 0 then return end
        local entry = row and copy(row) or { name = output.name, label = output.label, slot = index,
            description = output.description, metadata = outputMetadata, stack = true, close = output.close, count = 0 }
        local oldWeight = row and row.weight or 0
        entry.count = entry.count + count
        entry.weight = weight(output, entry)
        totalWeight = totalWeight - oldWeight + entry.weight
        nextItems[index], changes[index], remaining = entry, true, remaining - count
    end
    for i = 1, inv.slots do
        local row = nextItems[i]
        if remaining > 0 and row and row.name == output.name and matches(row.metadata, outputMetadata) then put(i, row) end
    end
    for i = 1, inv.slots do
        if remaining > 0 and not nextItems[i] then put(i) end
    end
    if remaining > 0 or totalWeight > inv.maxWeight then return nil, 'weight' end
    return { items = nextItems, weight = totalWeight, changes = changes, removed = removed, added = added,
        kind = packing and 'packed' or 'unpacked' }
end

-- Tickets are server-issued and bind to this inventory object, slot and its
-- exact current content. A replay after restart is unknown, never a new grant.
function Exchange.new(deps)
    local tickets, nextId, active = {}, 0, {}
    local api = {}
    function api.prepare(src, slot)
        if not integer(slot) then return nil end
        local inv = deps.inventory(src)
        local row = inv and inv.items[slot]
        local item = row and deps.item(row.name)
        if not item or not (item.ammoPack or item.ammoUnpack) then return nil end
        local now = deps.now()
        local record = tickets[src]
        -- One pending intent per player; spamming prepare cannot queue many conversions.
        if record and not record.result and record.expires > now and record.inv == inv
            and record.slot == slot and record.row == row and record.count == row.count then return record.id end
        nextId = nextId + 1
        local id = tostring(now) .. ':' .. tostring(nextId)
        tickets[src] = { id = id, inv = inv, slot = slot, row = row, count = row.count,
            metadata = deps.encode(row.metadata), expires = now + 30000 }
        return id
    end
    function api.execute(src, slot, id)
        local record = tickets[src]
        if not record or type(id) ~= 'string' or record.id ~= id or record.slot ~= slot then return false, 'invalid' end
        if record.result then return table.unpack(record.result) end
        if active[src] then return false, 'busy' end
        active[src] = true
        local ok, success, reason, amount = pcall(function()
            local inv = deps.inventory(src)
            local row = inv and inv.items[slot]
            if record.expires < deps.now() or inv ~= record.inv or row ~= record.row or row.count ~= record.count
                or deps.encode(row.metadata) ~= record.metadata then return false, 'invalid' end
            local input = deps.item(row.name)
            local packing = input.ammoPack ~= nil
            local output = deps.item(input.ammoPack or input.ammoUnpack)
            if not output then return false, 'invalid' end
            local size = packing and output.ammocount or input.ammocount
            local metadata = deps.metadata(inv, output)
            -- Metadata hooks may yield. Revalidate before entering the no-yield plan/commit.
            if inv.items[slot] ~= row or row.count ~= record.count or deps.encode(row.metadata) ~= record.metadata then return false, 'invalid' end
            local plan, error, need = Exchange.plan(inv, slot, input, output, metadata, packing, size,
                deps.weight, deps.maxStack, deps.matches)
            if not plan then return false, error, need end
            inv.items, inv.weight, inv.changed = plan.items, plan.weight, true
            record.result = { true, plan.kind, plan.added }
            -- Publish/save one complete state; never run independent AddItem/RemoveItem calls.
            deps.publish(inv, plan, row, output, id)
            return table.unpack(record.result)
        end)
        active[src] = nil
        if not ok and deps.error then deps.error(success) end
        if record.result then return table.unpack(record.result) end
        record.result = ok and { success, reason, amount } or { false, 'invalid' }
        return table.unpack(record.result)
    end
    function api.clear(src) tickets[src], active[src] = nil, nil end
    return api
end

return Exchange
