local Decay = {}
function Decay.update(metadata, definition, now, modifier)
    local minutes = definition and tonumber(definition.decay)
    if not minutes or minutes <= 0 then return false, nil, false end
    now = now or os.time()
    if metadata.quality == nil or metadata.lastUpdate == nil then
        metadata.quality = metadata.quality or 100
        metadata.lastUpdate = now
        return true, metadata.quality, definition.delete == true
    end
    local elapsed = math.max(0, now - metadata.lastUpdate)
    if elapsed == 0 then return false, metadata.quality, definition.delete == true end
    local quality = math.max(0, metadata.quality - elapsed * 100 / (minutes * 60) * (modifier or 1))
    metadata.quality = math.floor(quality * 10 + 0.5) / 10
    metadata.lastUpdate = now
    return true, metadata.quality, definition.delete == true
end
return Decay
