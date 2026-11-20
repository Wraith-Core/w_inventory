-- Universal w_lib client bridge for w_inventory: works with any framework supported by w_lib.
local Weapon = require 'modules.weapon.client'

exports.w_lib:FwOnCharacterUnloaded(client.onLogout)

exports.w_lib:FwOnJobUpdate(function(job)
    if not PlayerData.loaded or type(job) ~= 'table' then return end
    local grade = type(job.grade) == 'table' and (job.grade.level or 0) or (tonumber(job.grade) or 0)
    PlayerData.groups = PlayerData.groups or {}
    PlayerData.groups[job.name or 'unemployed'] = tonumber(grade) or 0
    OnPlayerData('groups', PlayerData.groups)
end)

exports.w_lib:FwOnGangUpdate(function(gang)
    if not PlayerData.loaded or type(gang) ~= 'table' then return end
    local grade = type(gang.grade) == 'table' and (gang.grade.level or 0) or (tonumber(gang.grade) or 0)
    PlayerData.groups = PlayerData.groups or {}
    PlayerData.groups[gang.name or 'none'] = tonumber(grade) or 0
    OnPlayerData('groups', PlayerData.groups)
end)

---@diagnostic disable-next-line: duplicate-set-field
function client.setPlayerStatus(values)
    for name, value in pairs(values) do
        if value > 100 or value < -100 then
            value = value * 0.0001
        end
        if GetResourceState('w_hud') == 'started' then
            local ok, pd = pcall(function() return exports.w_lib:FwGetPlayerData() end)
            local meta = ok and type(pd) == 'table' and pd.metadata or {}
            if name == 'hunger' or name == 'thirst' then
                local cur = tonumber(meta[name]) or 100
                TriggerServerEvent('w_hud:server:setNeed', name, cur + value)
            end
        end
    end
end

AddStateBagChangeHandler('inv_busy', ('player:%s'):format(cache.serverId), function(_, _, value)
    LocalPlayer.state:set('invBusy', value, false)
end)
