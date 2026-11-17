-- Plain gathering goods created by the jobs editor on a Wraith Core host.
-- Each identifier has its own durable KVP; native items are never overwritten.
return function(catalog, names, items, apply)
    local prefix, registered = 'gathering:material:', {}
    local function validKey(key)
        return type(key) == 'string' and #key <= 48 and key:match('^[a-z][a-z0-9_]+$')
            and not key:match('^weapon_') and not key:match('^ammo_')
    end
    local function label(s)
        if type(s) ~= 'string' or s:find('%c') then return nil end
        s = s:match('^%s*(.-)%s*$')
        local n = utf8.len(s)
        return n and n > 0 and n <= 48 and s or nil
    end
    local function put(key, ar, en)
        local raw = { name = key, label_ar = ar, label_en = en, label = en, type = 'item',
            image = 'rock.png', weight = 300, unique = false, useable = false, shouldClose = true }
        local row = { name = key, label = en, label_ar = ar, label_en = en, description = '',
            weight = raw.weight, stack = true, close = true, nativeSource = 'wcore', nativeName = key,
            nativeType = 'item', nativeDefinition = raw, client = { image = raw.image } }
        catalog[key], registered[key] = row, { ar = ar, en = en }
        apply(items, { [key] = row }, false)
        shared.localizeItemData(items[key])
        return row
    end
    if shared.backend == 'wcore' then
        local scan = StartFindKvp(prefix)
        if scan ~= -1 then
            while true do
                local path = FindKvp(scan)
                if not path then break end
                local key = path:sub(#prefix + 1)
                local ok, def = pcall(json.decode, GetResourceKvpString(path) or '')
                if validKey(key) and not items[key] and not catalog[key] and ok and type(def) == 'table'
                    and label(def.ar) and label(def.en) then put(key, def.ar, def.en) end
            end
            EndFindKvp(scan)
        end
    end
    exports('GatheringMaterials', function() return registered end)
    exports('EnsureGatheringMaterial', function(key, ar, en)
        if shared.backend ~= 'wcore' or GetInvokingResource() ~= 'w_jobs' or not shared.ready then return false, 'unavailable' end
        ar = label(ar)
        en = (en == nil or type(en) == 'string' and en:match('^%s*$')) and ar or label(en)
        if not validKey(key) or not ar or not en then return false, 'invalid' end
        if (items[key] or catalog[key]) and not registered[key] then return false, 'conflict' end
        local current = registered[key]
        if current then
            if current.ar == ar and current.en == en then return true end
            return false, 'conflict'
        end
        local path, raw = prefix .. key, json.encode({ ar = ar, en = en })
        SetResourceKvp(path, raw)
        if GetResourceKvpString(path) ~= raw then return false, 'unavailable' end
        local row = put(key, ar, en)
        -- Append without changing the order of pages a logging-in player is reading.
        names[#names + 1] = key
        TriggerClientEvent('w_inventory:gatheringMaterial', -1, key, row)
        TriggerEvent('w_inventory:gatheringMaterialChanged', key)
        return true
    end)
end
