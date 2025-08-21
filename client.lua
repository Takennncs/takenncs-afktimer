local QBCore = exports['qb-core']:GetCoreObject()
local afkTime = 0
local lastPos = nil

CreateThread(function()
    while true do
        Wait(1000) 

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        if lastPos == nil then
            lastPos = coords
        end

        if #(coords - lastPos) > 1.0 then
            afkTime = 0
        else
            afkTime = afkTime + 1
        end

        if afkTime > 0 and afkTime % Config.AfkWarningInterval == 0 then
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                args = {"AFK", "Sa ei ole pikemat aega liigutanud. Kirjuta /afktimer, et nullida AFK taimer."}
            })
        end

        if afkTime >= Config.AfkKickTime then
            TriggerServerEvent("takenncs-afktimer:kickPlayer")
        end

        lastPos = coords
    end
end)

RegisterCommand("afktimer", function()
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        args = {"AFK TIMER", "Aega edukalt uuendautd!"}
    })
    afkTime = 0
end, false)
