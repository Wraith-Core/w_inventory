local function addDeferral(err)
    err = err:gsub("%^%d", "")

    AddEventHandler('playerConnecting', function(_, _, deferrals)
        deferrals.defer()
        deferrals.done(err)
    end)
end

-- Runtime settings are read from convars here; config.lua carries the gameplay settings.

shared = {
    resource = GetCurrentResourceName(),
    framework = GetConvar('inventory:framework', 'auto'),
    playerslots = GetConvarInt('inventory:slots', 50),
    playerweight = GetConvarInt('inventory:weight', 30000),
    police = json.decode(GetConvar('inventory:police', '["police"]')),
}

do
    if type(shared.police) == 'string' then
        shared.police = { shared.police }
    end

    local police = table.create(0, shared.police and #shared.police or 0)

    for i = 1, #shared.police do
        police[shared.police[i]] = 0
    end

    shared.police = police
end

if IsDuplicityVersion() then
    server = {
        bulkstashsave = GetConvarInt('inventory:bulkstashsave', 1) == 1,
        loglevel = GetConvarInt('inventory:loglevel', 1),
        randomprices = GetConvarInt('inventory:randomprices', 0) == 1,
        evidencegrade = GetConvarInt('inventory:evidencegrade', 2),
    }

    local accounts = json.decode(GetConvar('inventory:accounts', '["money"]'))
    server.accounts = table.create(0, #accounts)

    for i = 1, #accounts do
        server.accounts[accounts[i]] = 0
    end
else
    PlayerData = {}
    client = {
        autoreload = GetConvarInt('inventory:autoreload', 0) == 1,
        -- controls that stay usable while the bag is open (RDR3 control names or hashes);
        -- the default keeps push-to-talk working
        enablekeys = json.decode(GetConvar('inventory:enablekeys', '["INPUT_PUSH_TO_TALK"]')) or {},
        aimedfiring = GetConvarInt('inventory:aimedfiring', 0) == 1,
        giveplayerlist = GetConvarInt('inventory:giveplayerlist', 0) == 1,
        itemnotify = GetConvarInt('inventory:itemnotify', 1) == 1,
        weaponnotify = GetConvarInt('inventory:weaponnotify', 1) == 1,
        imagepath = GetConvar('inventory:imagepath', 'nui://w_inventory/web/images'),
        dropprops = GetConvarInt('inventory:dropprops', 1) == 1,
        dropmodel = joaat(GetConvar('inventory:dropmodel', 'p_bag01x')),
        weaponmismatch = GetConvarInt('inventory:weaponmismatch', 1) == 1,
        ignoreweapons = json.decode(GetConvar('inventory:ignoreweapons', '[]')),
        weaponWheel = GetConvarInt('inventory:weaponWheel', 0) == 1,
    }

    -- control names are hashed the way the game hashes them (joaat)
    for i = 1, #client.enablekeys do
        local control = client.enablekeys[i]
        client.enablekeys[i] = tonumber(control) or joaat(tostring(control))
    end

    local ignoreweapons = table.create(0, (client.ignoreweapons and #client.ignoreweapons or 0) + 2)

    for i = 1, #client.ignoreweapons do
        local weapon = client.ignoreweapons[i]
        ignoreweapons[tonumber(weapon) or joaat(weapon)] = true
    end

    ignoreweapons[`WEAPON_UNARMED`] = true
    ignoreweapons[`OBJECT`] = true

    client.ignoreweapons = ignoreweapons
end

function shared.print(...) print(string.strjoin(' ', ...)) end

function shared.info(...) shared.print('^2[info]^7', ...) end

---Throws a formatted type error.
---```lua
---error("expected %s to have type '%s' (received %s)")
---```
---@param variable string
---@param expected string
---@param received string
function TypeError(variable, expected, received)
    error(("expected %s to have type '%s' (received %s)"):format(variable, expected, received))
end

-- People like ignoring errors for some reason
local function spamError(err)
    shared.ready = false

    CreateThread(function()
        while true do
            Wait(10000)
            CreateThread(function()
                error(err, 0)
            end)
        end
    end)

    addDeferral(err)
    error(err, 0)
end

-- Framework selection has one server-authoritative result and requires no cfg entry.
-- A manual inventory:framework value remains available only as an emergency override.
local frameworkAliases = {
    auto = 'auto',
    vorp = 'vorp',
    vorpcore = 'vorp',
    vorp_core = 'vorp',
    rsg = 'rsg',
    rsgcore = 'rsg',
    ['rsg-core'] = 'rsg',
    rsg_v2 = 'rsg',
    qbr = 'qbr',
    qbrcore = 'qbr',
    ['qbr-core'] = 'qbr',
}

local frameworkResources = {
    vorp = 'vorp_core',
    rsg = 'rsg-core',
    qbr = 'qbr-core',
}

local function normalizeFramework(value)
    value = tostring(value or ''):lower():gsub('%s+', '')
    if value == '' then value = 'auto' end
    return frameworkAliases[value]
end

local function resourceStarted(resource)
    return GetResourceState(resource) == 'started'
end

local function frameworkFromWLib()
    if GetResourceState('w_lib') ~= 'started' then return nil end

    local ok, name = pcall(function()
        return exports.w_lib:FwName()
    end)

    return ok and normalizeFramework(name) or nil
end

local function runningFrameworks()
    local found = {}

    for name, resource in pairs(frameworkResources) do
        if resourceStarted(resource) then
            found[#found + 1] = name
        end
    end

    return found
end

local function resolveFramework()
    local ok, status = pcall(function() return exports.w_lib:CompatStatus() end)
    if ok and status and status.inboundAliases then return 'rsg', 'w_lib (Wraith host)' end
    local configuredRaw = GetConvar('inventory:framework', 'auto')
    local configured = normalizeFramework(configuredRaw)

    if not configured then
        return nil, ("Unsupported inventory:framework value '%s'. Supported values: auto, vorp, rsg, qbr.")
            :format(tostring(configuredRaw))
    end

    local replicated = normalizeFramework(GetConvar('w_inventory:framework', ''))

    for _ = 1, 150 do
        if configured ~= 'auto' then
            if resourceStarted(frameworkResources[configured]) then
                return configured, 'configured'
            end
        elseif not IsDuplicityVersion() and replicated and replicated ~= 'auto'
            and resourceStarted(frameworkResources[replicated]) then
            return replicated, 'server'
        else
            local fromLibrary = frameworkFromWLib()
            local running = runningFrameworks()

            if fromLibrary and fromLibrary ~= 'auto' and resourceStarted(frameworkResources[fromLibrary]) then
                return fromLibrary, 'w_lib'
            end

            if #running == 1 then
                return running[1], 'resource'
            elseif #running > 1 then
                return nil, ('Multiple frameworks are running (%s). Stop the unused core or set inventory:framework explicitly.')
                    :format(table.concat(running, ', '))
            end
        end

        Wait(200)
        replicated = normalizeFramework(GetConvar('w_inventory:framework', ''))
    end

    if configured ~= 'auto' then
        return nil, ("Framework '%s' was selected but resource '%s' is not started.")
            :format(configured, frameworkResources[configured])
    end

    return nil, 'No supported framework is running. Start vorp_core, rsg-core, or qbr-core before w_inventory.'
end

if not lib then
    return spamError('w_inventory requires the w_lib resource, refer to the documentation.')
end

local success, msg = lib.checkDependency('oxmysql', '2.7.3')

if success then
    -- 4.0.0: the callback wire (__w_cb_*) and the module loader changed; older builds cannot answer us
    success, msg = lib.checkDependency('w_lib', '4.0.0')
end

if not success then
    return spamError(msg)
end

-- ── Language ────────────────────────────────────────────────────────────────────
-- The library owns the language: w.getLocaleKey() is the player's choice (KVP) on the
-- client and the `w_lib:locale` convar on the server. The resource keeps no language
-- setting of its own; anything that is not 'ar' is shown in English.
-- shared.localeKey() is the cached, normalised key ('ar' | 'en') every reader uses
-- (item labels, ammunition labels, the NUI direction).
do
    local function normalise(key)
        return tostring(key or 'en'):lower():sub(1, 2) == 'ar' and 'ar' or 'en'
    end

    local cached

    function shared.localeKey()
        if not cached then
            local ok, key = pcall(function() return exports.w_lib:getLocaleKey() end)
            cached = normalise(ok and key or 'en')
        end

        return cached
    end

    if not IsDuplicityVersion() then
        -- the player switched the language in /w_lib: refresh the cache before any other
        -- handler of ours reads it (this file's handler is registered first)
        AddEventHandler('w_lib:setLocale', function(key)
            cached = normalise(key)
        end)
    end
end

local framework, frameworkSource = resolveFramework()

if not framework then
    return spamError(frameworkSource)
end

shared.framework = framework
-- Wraith provides the RSG player API, but its weapons belong to w_inventory.
-- An actual RSG host still uses rsg-weapons, even while that resource is restarting.
shared.backend = exports.w_lib:FwBackend()
shared.nativeRsgWeapons = framework == 'rsg' and shared.backend ~= 'wcore'

if IsDuplicityVersion() then
    SetConvarReplicated('w_inventory:framework', framework)
    print(('^2[w_inventory]^7 framework -> %s (%s)'):format(framework, frameworkSource))
end

if not LoadResourceFile(shared.resource, 'web/build/index.html') then
    return spamError(
        'UI has not been built.')
end

if lib.context == 'server' then
    shared.ready = false
    return require 'server'
end

require 'client'
