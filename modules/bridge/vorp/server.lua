local cashFromCore = {}
local Inventory = require 'modules.inventory.server'
local Items = require 'modules.items.server'
require 'modules.bridge.vorp.compat'

-- ! Do not call GetCore() here directly.
-- If vorp_core were not ready yet the whole bridge's loading would fail, and then
-- modules/bridge/server.lua sets lib = nil so the bag dies silently.
local Core

local function getCore()
    if not Core then
        local ok, core = pcall(function()
            return exports.vorp_core:GetCore()
        end)
        Core = ok and core or nil
    end
    return Core
end

---Reading the player's active character
---@param source integer
---@return table|nil
local function getCharacter(source)
    local core = getCore()
    if not core then return nil end

    local user = core.getUser(source)
    if not user then return nil end
    return user.getUsedCharacter
end

---The bag's storage key: the character's id and not the player's account
---@param character table
---@return string
local function getIdentifier(character)
    return tostring(character.charIdentifier)
end

---The shown name
---@param character table
---@return string
local function getName(character)
    return ('%s %s'):format(character.firstname or '', character.lastname or '')
end

-- ============================================================
-- Setting the player up when the character is chosen
-- ============================================================
---@param source integer
---@param character? table the character if the event passed it, otherwise we fetch it
local function setupPlayer(source, character)
    source = tonumber(source)
    if not source then
        return
    end

    character = character or getCharacter(source)
    if not character then
        return
    end

    local identifier = getIdentifier(character)

    -- * The import before reading the bag, not after it.
    --
    -- After it the player has already loaded an empty bag, and the first save writes it over what
    -- we imported - so he loses his items twice instead of once. Off by default:
    --     setr w_inventory:autoimport 1
    -- Native storage reads character_inventories/items_crafted/loadout directly.

    local ok, err = pcall(server.setPlayerInventory, {
        source = source,
        identifier = identifier,
        name = getName(character),
    })

    if not ok then
        print(('[w_inventory] native VORP character load failed: %s'):format(tostring(err)))
        return
    end

    -- ! setPlayerInventory throws no error if Inventory.Create fails - it just goes quiet.
    -- So we check that the bag really exists and not that no error happened.
    local inv = Inventory(source)

    if not inv then
        return
    end


    -- On VORP, money and gold are character wallet currencies shown in the UI header.
    TriggerClientEvent('w_inventory:updateCurrency', source, character.money or 0, character.gold or 0)
end

-- ! This is a local event and not a networked one. vorp_core fires it like this:
--     TriggerEvent("vorp:SelectedCharacter", self.source, player)
-- So the source is the first argument, and there is no implicit source here.
AddEventHandler('vorp:SelectedCharacter', function(playerSource, character)
    setupPlayer(playerSource, character)
end)

-- ════════════════════════════════════════════════════════════════════════════
-- Restarting the resource during play
--
-- * 'vorp:SelectedCharacter' is fired once when the character is chosen and never again.
--   So after `restart w_inventory` the client stays with no PlayerData until he leaves and comes back:
--   the bag does not open, and w_hud's wheel says 'getWeaponWheelState did not return a ready
--   state - restart w_inventory' so the server owner restarts it... and the same state
--   repeats. The server is the one that takes the initiative here: it goes over every connected player who has
--   a loaded character and sets him up again.
-- ════════════════════════════════════════════════════════════════════════════
AddEventHandler('onServerResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end

    CreateThread(function()
        Wait(2000) -- a delay until vorp_core and the database are ready

        local restored = 0

        for _, id in ipairs(GetPlayers()) do
            local src = tonumber(id)
            local character = src and getCharacter(src)

            -- No loaded character = the player is on the selection screen; his event will come by itself.
            if character then
                setupPlayer(src, character)
                restored = restored + 1
            end
        end

        if restored > 0 then
            print(('[w_inventory] re-initialised %d player(s) after resource restart'):format(restored))
        end
    end)
end)

AddEventHandler('playerDropped', function()
    server.playerDropped(source)
end)

-- Replicate VORP's compatibility flag from the server so this remains valid
-- when sv_stateBagStrictMode is enabled. The value is informational only.
RegisterNetEvent('w_inventory:vorp:setInventoryActive', function(active)
    local player = Player(source)
    if player then player.state:set('IsInvActive', active == true, true) end
end)

-- ============================================================
-- Syncing the money: from the character to the bag
--
-- In the bag the money is an item, and in VORP a balance on the character.
-- And VORP fires no event when it changes; it writes it into a statebag instead:
--     SetState(source, "Character", "Money", value)   character.lua:369
-- So we listen for that so any money given by an admin or any script shows up.
-- ============================================================
AddStateBagChangeHandler('Character', nil, function(bagName, _, value)
    if type(value) ~= 'table' or value.Money == nil then return end

    local source = tonumber(bagName:match('player:(%d+)'))
    if not source then return end

    local inventory = Inventory(source)
    if not inventory then return end

    local money = tonumber(value.Money) or 0
    TriggerClientEvent('w_inventory:updateCurrency', source, money, tonumber(value.Gold) or 0)
    if shared.backend ~= 'wcore' then return end

    local current = Inventory.GetItemCount(source, 'money')

    -- The condition breaks the loop: syncInventory writes to the character so the event comes back to us
    if current == money then return end

    cashFromCore[source] = true
    local inv = Inventory(source)
    if inv then Inventory.SetSlotCount(inv, math.max(inv.slots, 1 + (function() local n=0; for _ in pairs(inv.items) do n=n+1 end; return n end)())) end
    Inventory.SetItem(source, 'money', money)
    if inv then inv.nativeCashObserved = Inventory.GetItemCount(inv, 'money') end
    cashFromCore[source] = nil
end)

-- The players already connected when the resource restarts
SetTimeout(500, function()
    for _, playerId in ipairs(GetPlayers()) do
        local source = tonumber(playerId)
        if source and getCharacter(source) then
            setupPlayer(source)
        end
    end
end)

-- ============================================================
-- The bridge's contract
-- ============================================================

---@diagnostic disable-next-line: duplicate-set-field
function server.GetPlayerFromId(source)
    return getCharacter(source)
end

---@diagnostic disable-next-line: duplicate-set-field
function server.setPlayerData(player)
    local character = getCharacter(player.source)

    if not character then
        return {
            source = player.source,
            name = player.name,
            groups = {},
        }
    end

    local job = character.job
    local grade = tonumber(character.jobGrade) or 0

    return {
        source = player.source,
        name = getName(character),
        groups = job and { [job] = grade } or {},
        sex = character.skin and 'male' or nil,
        dateofbirth = nil,
        job = job,
        charid = character.charIdentifier,
    }
end

--- Writing the stock and the money to the character
---@diagnostic disable-next-line: duplicate-set-field
local NativeSettings = require 'modules.bridge.vorp.settings'
function server.inventoryLimits(source)
    local character = getCharacter(source)
    local capacity = character and tonumber(character.invCapacity)
    return NativeSettings.slots, capacity and (capacity < 0 and 1000000000000 or capacity * 1000) or shared.playerweight
end

function server.canCarryNativeWeapon(inv, item, count)
    inv = Inventory(inv)
    if not inv or not inv.player then return true end
    local config = NativeSettings.maxWeapons
    local white = config.WHITELIST or {}
    if item and white[item.name] then return true end
    local character = getCharacter(inv.id)
    local limit = config.JOBS and character and config.JOBS[character.job] or config.PLAYERS or 10
    if limit < 0 then return true end
    local total = 0
    for _, row in pairs(inv.items) do
        if row.name:sub(1, 7) == 'WEAPON_' and not white[row.name] then total = total + row.count end
    end
    return total + (tonumber(count) or 1) <= limit
end

function server.nativeCashBalance(source)
    local character = getCharacter(source)
    return character and tonumber(character.money) or nil
end

function server.adjustNativeCash(source, delta)
    local character = getCharacter(source)
    local amount = tonumber(delta)
    if not character or not amount or amount == 0 then return false, 'invalid_count' end
    if amount > 0 then
        character.addCurrency(0, amount)
    else
        local need = -amount
        if (tonumber(character.money) or 0) < need then return false, 'not_enough_money' end
        character.removeCurrency(0, need)
    end
    TriggerClientEvent('w_inventory:updateCurrency', source, tonumber(character.money) or 0, tonumber(character.gold) or 0)
    return true
end

function server.syncInventory(inv)
    if shared.backend ~= 'wcore' then return end
    local accounts = Inventory.GetAccountItemCounts(inv)
    if not accounts then return end

    local character = getCharacter(inv.id)
    if not character or tostring(character.charIdentifier) ~= tostring(inv.owner) then return end

    local money = accounts.money or 0
    local observed = inv.nativeCashObserved
    inv.nativeCashObserved = money
    if observed == nil or cashFromCore[inv.id] then return end
    local diff = money - observed

    if diff > 0 then
        character.addCurrency(0, diff)
    elseif diff < 0 then
        character.removeCurrency(0, math.abs(diff))
    end
end

-- server.UseItem is defined in compat.lua because it is tied to the registry
-- of usable items that registerUsableItem fills

---@diagnostic disable-next-line: duplicate-set-field
function server.isPlayerBoss(playerId)
    local character = getCharacter(playerId)
    if not character then return false end
    return character.isjobboss == true or character.isJobBoss == true
end

-- Licences are not supported in VORP
---@diagnostic disable-next-line: duplicate-set-field
function server.hasLicense()
    return false
end

-- ============================================================
-- Refreshing the player's data after his job changes
-- Any jobs script calls it after changing the player's job:
--     TriggerEvent('w_inventory:refreshPlayerData', source)
-- Note: VORP fires no standard event for a job change, so the refresh is manual
-- ============================================================
AddEventHandler('w_inventory:refreshPlayerData', function(playerId)
    local source = playerId or source
    local inventory = Inventory(source)
    if not inventory or not inventory.player then return end

    inventory.player = server.setPlayerData({ source = source })
end)
