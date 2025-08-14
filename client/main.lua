local SpeedCamera = require('shared/classes/speedcamera')
local Config      = require('shared/config')
local ESX = exports['es_extended']:getSharedObject()

CreateThread(function()
    while not ESX.IsPlayerLoaded() do
        Wait(500)
    end

    local cameras = {}
    for i, data in ipairs(Config.Setup['SpeedCams']) do
        cameras[#cameras + 1] = SpeedCamera:new(i, data)
    end

    lib.print.info(('[Speedcams] %d cams loaded.'):format(#cameras))
end)