-- Native item hashes are NOT model or texture hashes.
-- ITEMDATABASE_FILLOUT_ITEM_INFO: model is the fourth aligned Hash (offset 24).
-- https://github.com/alloc8or/rdr3-nativedb-data/blob/master/natives.json
local Assets = {}
local models = {}

function Assets.model(itemHash, fallback)
    if type(itemHash) ~= 'number' or itemHash == 0 then return fallback end
    if models[itemHash] ~= nil then return models[itemHash] or fallback end

    local ok, model = pcall(function()
        if not Citizen.InvokeNative(0x6D5D51B188333FD1, itemHash, 0) then return end
        local info = DataView.ArrayBuffer(8 * 8)
        if not Citizen.InvokeNative(0xFE90ABBCBFDC13B2, itemHash, info:Buffer()) then return end
        local hash = info:GetUint32(3 * 8)
        if hash ~= 0 and IsModelValid(hash) and IsModelInCdimage(hash) then return hash end
    end)

    models[itemHash] = ok and model or false
    return models[itemHash] or fallback
end

return Assets
