-- RSG owns players.inventory. W uses count/metadata only while a row is in memory.
-- The private envelope preserves native row extensions and is removed on export.
local Codec = {}
local envelopeKey = '_w_rsg'

local function clone(value)
    if type(value) ~= 'table' then return value end
    local result = {}
    for key, entry in pairs(value) do result[key] = clone(entry) end
    return result
end

local function rows(value)
    if value == nil or value == '' then return {} end
    if type(value) == 'string' then value = json.decode(value) end
    if type(value) ~= 'table' then error('RSG inventory must be an array or slot map', 2) end
    return value
end

local function validRow(row, key, native, currency)
    if type(row) ~= 'table' or type(row.name) ~= 'string' or row.name == '' then
        error(('Invalid RSG inventory item at %s'):format(tostring(key)), 3)
    end
    local slot = tonumber(row.slot) or tonumber(key)
    local count = tonumber(native and row.amount or row.count)
    if not slot or slot < 1 or slot % 1 ~= 0 or not count or count ~= count or count == math.huge
        or count <= 0 or (not currency and count % 1 ~= 0) then
        error(('Invalid RSG inventory quantity or slot for %s'):format(row.name), 3)
    end
    return slot, count
end

function Codec.decode(value)
    local result, occupied = {}, {}
    for key, row in pairs(rows(value)) do
        local native = row.amount ~= nil
        local slot, count = validRow(row, key, native)
        if occupied[slot] then error(('Duplicate RSG inventory slot %s'):format(slot)) end
        occupied[slot] = true
        local info = native and row.info or row.metadata
        if info == nil or info == '' then info = {} end
        if type(info) ~= 'table' then error(('Invalid RSG item info for %s'):format(row.name)) end
        local metadata = clone(info)
        if native then
            local extra = {}
            for field, entry in pairs(row) do
                if field ~= 'name' and field ~= 'amount' and field ~= 'info' and field ~= 'type' and field ~= 'slot' then
                    extra[field] = clone(entry)
                end
            end
            metadata[envelopeKey] = {
                version = 1, nativeType = row.type, nativeName = row.name, extra = extra,
                originalEnvelope = clone(info[envelopeKey]),
            }
        end
        result[#result + 1] = { name = row.name, count = count, slot = slot, metadata = metadata }
    end
    table.sort(result, function(a, b) return a.slot < b.slot end)
    return result
end

local function toNativeItem(row, definition, currency)
    local slot, count = validRow(row, row.slot, false, currency)
    local info = clone(row.metadata or {})
    if type(info) ~= 'table' then error(('Invalid RSG item metadata for %s'):format(row.name)) end
    local envelope = info[envelopeKey]
    local native = {}
    if type(envelope) == 'table' and envelope.version == 1 then
        native = clone(envelope.extra or {})
        info[envelopeKey] = clone(envelope.originalEnvelope)
    else
        envelope = nil
    end
    native.name = definition and definition.nativeName or envelope and envelope.nativeName or row.name:lower()
    native.amount = count
    native.slot = slot
    native.info = info
    native.type = envelope and envelope.nativeType or row.type
        or (definition and (definition.nativeType or (definition.weapon and 'weapon' or 'item')))
        or (row.name:lower():sub(1, 7) == 'weapon_' and 'weapon' or 'item')
    return native
end

function Codec.toNativeItem(row, definition)
    return toNativeItem(row, definition, false)
end

-- Currency is a wallet mirror, may include cents, and is never encoded into players.inventory.
-- Ordinary items retain the positive-integer contract above.
function Codec.toNativeCurrency(row)
    if row.name ~= 'money' and row.name ~= 'gold' then error('Invalid RSG currency', 2) end
    local native = toNativeItem(row, nil, true)
    native.type = 'currency'
    return native
end

function Codec.encode(value, definitions)
    local result, occupied = {}, {}
    for key, row in pairs(rows(value)) do
        if row.name ~= 'money' and row.name ~= 'gold' then
        local copy = clone(row)
        copy.slot = tonumber(copy.slot) or tonumber(key)
        local definition = definitions and definitions(copy.name)
        local native = Codec.toNativeItem(copy, definition)
        if occupied[native.slot] then error(('Duplicate RSG inventory slot %s'):format(native.slot)) end
        occupied[native.slot] = true
        result[#result + 1] = native
        end
    end
    table.sort(result, function(a, b) return a.slot < b.slot end)
    return json.encode(result)
end

return Codec
