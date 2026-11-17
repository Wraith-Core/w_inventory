-- Prepare every line before touching the bag. The completed plan contains full
-- slot values, so publication cannot expose a half-delivered order.
local Cart = {}

function Cart.plan(inv, lines, api, consume)
    if not inv or not inv.slots then return nil, 'invalid_inventory' end
    if type(lines) ~= 'table' or #lines < 1 or #lines > 12 then return nil, 'invalid_cart' end
    local prepared, totals = {}, {}
    for _, line in ipairs(lines) do
        if type(line) ~= 'table' then return nil, 'invalid_cart' end
        local count = line.count
        if type(count) ~= 'number' or count ~= count or count % 1 ~= 0 or count < 1 or count > 100 then
            return nil, 'invalid_count'
        end
        local item = api.item(line.item)
        if not item then return nil, 'invalid_item' end
        if not api.allowed(item) then return nil, 'not_in_native_catalog' end
        totals[item.name] = (totals[item.name] or 0) + count
        if item.nativeGunbelt and not inv.player then return nil, 'invalid_item' end
        if item.nativeSource == 'vorp' and inv.player then
            local limit = item.gunbeltLimit or item.limit or -1
            if limit >= 0 and api.count(inv, item.name) + totals[item.name] > limit then return nil, 'item_limit' end
        end
        if item.weapon and not api.weapon(inv, item, totals[item.name]) then return nil, 'weapon_limit' end
        local remaining = count
        while remaining > 0 do
            local meta, amount = api.metadata(inv, item, api.copy(line.metadata or {}), item.stack and remaining or 1)
            if type(meta) ~= 'table' or type(amount) ~= 'number' or amount < 1 or amount > remaining or amount % 1 ~= 0 then return nil, 'invalid_metadata' end
            prepared[#prepared+1] = { item = item, count = amount, metadata = meta }
            remaining = remaining - amount
        end
    end
    -- Metadata hooks can yield. Read the live bag only after all hooks finish.
    local slots, weight = api.copy(inv.items), inv.weight
    local changed, additions = {}, {}
    if consume then
        local def, sources = api.item(consume.item), {}
        if not def then return nil, 'invalid_item' end
        for slot, row in pairs(slots) do
            if row.name == def.name then sources[#sources + 1] = slot end
        end
        -- Free the smallest stacks first so a full bag can still exchange a whole stack.
        table.sort(sources, function(a, b)
            return slots[a].count < slots[b].count or (slots[a].count == slots[b].count and a < b)
        end)
        local left = consume.count
        for _, slot in ipairs(sources) do
            local row = slots[slot]
            local take = math.min(row.count, left)
            weight = weight - row.weight
            row.count, left, changed[slot] = row.count - take, left - take, true
            if row.count == 0 then slots[slot] = nil
            else row.weight = api.weight(def, row); weight = weight + row.weight end
            if left == 0 then break end
        end
        if left > 0 then return nil, 'not_enough_items' end
    end
    for _, entry in ipairs(prepared) do
        local item, remaining = entry.item, entry.count
        for pass = 1, 2 do
            for slot = 1, inv.slots do
                if remaining == 0 then break end
                local current = slots[slot]
                local match = pass == 1 and item.stack and current and current.name == item.name
                    and api.matches(current.metadata or {}, entry.metadata)
                if match or (pass == 2 and not current) then
                    local capacity = (item.stack and api.maxStack(item.name) or 1) - (current and current.count or 0)
                    local amount = math.min(remaining, math.max(0, capacity))
                    if amount > 0 then
                        local meta = api.copy(entry.metadata)
                        if current then
                            local old = current.metadata or {}
                            meta._vorp, meta._w_rsg = old._vorp, old._w_rsg
                            if old.durability and meta.durability then
                                meta.durability = math.min(old.durability, meta.durability)
                                meta.degrade = old.degrade or meta.degrade
                            end
                        end
                        local row = {name=item.name, label=item.label, description=item.description, slot=slot,
                            count=(current and current.count or 0)+amount, metadata=meta, stack=item.stack, close=item.close}
                        row.weight = api.weight(item, row)
                        weight = weight - (current and current.weight or 0) + row.weight
                        slots[slot], changed[slot] = row, true
                        additions[slot] = (additions[slot] or 0) + amount
                        remaining = remaining - amount
                    end
                end
            end
        end
        if remaining > 0 then return nil, 'inventory_full' end
    end
    if weight > inv.maxWeight then return nil, 'weight_limit' end
    local shadow = {id=inv.id,player=inv.player,items=slots,__index=true}
    for _, entry in ipairs(prepared) do
        if entry.item.weapon and not api.weapon(shadow,entry.item,0) then return nil,'weapon_limit' end
    end
    return {items=slots, weight=weight, changed=changed, additions=additions}
end

return Cart
