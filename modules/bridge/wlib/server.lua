-- Universal w_lib server bridge for w_inventory: works with any framework supported by w_lib.
local Inventory = require 'modules.inventory.server'

local function playerSnapshot(src)
    local ok, pd = pcall(function() return exports.w_lib:FwGetPlayerData(src) end)
    if ok and type(pd) == 'table' and pd.citizenid then return pd end
    return nil
end

server.GetPlayerFromId = function(src)
    local pd = playerSnapshot(src)
    if not pd then return nil end
    return { PlayerData = pd }
end

local function buildPlayerTable(src, pd)
    local job = type(pd.job) == 'table' and pd.job or { name = 'unemployed', grade = { level = 0 } }
    local gang = type(pd.gang) == 'table' and pd.gang or { name = 'none', grade = { level = 0 } }
    local ci = type(pd.charinfo) == 'table' and pd.charinfo or {}
    local jobGrade = type(job.grade) == 'table' and (tonumber(job.grade.level) or 0) or (tonumber(job.grade) or 0)
    local gangGrade = type(gang.grade) == 'table' and (tonumber(gang.grade.level) or 0) or (tonumber(gang.grade) or 0)
    local name = ((tostring(ci.firstname or '') .. ' ' .. tostring(ci.lastname or '')):gsub('^%s+', ''):gsub('%s+$', ''))
    if name == '' then name = GetPlayerName(src) or tostring(pd.citizenid) end
    return {
        source = tonumber(src),
        identifier = tostring(pd.citizenid),
        name = name,
        job = job.name or 'unemployed',
        gang = gang.name or 'none',
        groups = {
            [job.name or 'unemployed'] = jobGrade,
            [gang.name or 'none'] = gangGrade,
        },
        sex = ci.gender,
        dateofbirth = ci.birthdate,
    }
end

local function setupPlayer(src)
    src = tonumber(src)
    if not src then return end
    local pd = playerSnapshot(src)
    if not pd then return end
    server.setPlayerInventory(buildPlayerTable(src, pd))
    local okC, cash = pcall(function() return exports.w_lib:FwGetMoney(src) end)
    local okG, gold = pcall(function() return exports.w_lib:FwGetGold(src) end)
    TriggerClientEvent('w_inventory:updateCurrency', src, okC and tonumber(cash) or 0, okG and tonumber(gold) or 0)
end

exports.w_lib:FwOnCharacterLoaded(function(src)
    setupPlayer(src)
end)

exports.w_lib:FwOnCharacterUnloaded(function(src)
    if server.playerDropped then server.playerDropped(tonumber(src) or src) end
end)

exports.w_lib:FwOnJobUpdate(function(src, job)
    local inv = Inventory(tonumber(src))
    if not inv or not inv.player then return end
    local name = type(job) == 'table' and job.name or tostring(job or 'unemployed')
    local grade = type(job) == 'table' and (type(job.grade) == 'table' and job.grade.level or job.grade) or 0
    if inv.player.job then inv.player.groups[inv.player.job] = nil end
    inv.player.job = name
    inv.player.groups[name] = tonumber(grade) or 0
end)

exports.w_lib:FwOnGangUpdate(function(src, gang)
    local inv = Inventory(tonumber(src))
    if not inv or not inv.player then return end
    local name = type(gang) == 'table' and gang.name or tostring(gang or 'none')
    local grade = type(gang) == 'table' and (type(gang.grade) == 'table' and gang.grade.level or gang.grade) or 0
    if inv.player.gang then inv.player.groups[inv.player.gang] = nil end
    inv.player.gang = name
    inv.player.groups[name] = tonumber(grade) or 0
end)

function server.syncInventory(inv)
    if not inv or not inv.id then return end
    local okC, cash = pcall(function() return exports.w_lib:FwGetMoney(inv.id) end)
    local okG, gold = pcall(function() return exports.w_lib:FwGetGold(inv.id) end)
    TriggerClientEvent('w_inventory:updateCurrency', inv.id, okC and tonumber(cash) or 0, okG and tonumber(gold) or 0)
end

function server.hasLicense()
    return true
end

function server.buyLicense()
    return false, 'unsupported'
end

function server.isPlayerBoss(playerId, group, grade)
    local pd = playerSnapshot(playerId)
    if not pd then return false end
    local role = (pd.job and pd.job.name == group) and pd.job or ((pd.gang and pd.gang.name == group) and pd.gang or nil)
    return role ~= nil and role.isboss == true
end

SetTimeout(500, function()
    for _, sid in ipairs(GetPlayers()) do
        local src = tonumber(sid)
        if src and not Inventory(src) then
            setupPlayer(src)
        end
    end
end)
