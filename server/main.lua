local Config = require('shared/config')
local CONST  = require('shared/const')
local ESX = exports['es_extended']:getSharedObject()

local MaxSpeeds = {}
for i, data in ipairs(Config.Setup['SpeedCams']) do
    MaxSpeeds[i] = data.MaxSpeed
end

lib.callback.register('sliss_speedcams:flash', function(src, camId, speed)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return false end

    local max = MaxSpeeds[camId]
    if not max or speed <= max then return false end

    speed = math.floor(math.max(0, tonumber(speed) or 0))

    local overspeed = speed - max
    local amount = math.floor(overspeed * CONST.PRICE_PER_KMH)
    if amount <= 0 or amount > CONST.MAX_SINGLE_FINE then
        return false
    end

    local now = os.time()
    local cds = Player(src).state.camCooldowns or {}
    if cds[camId] and now < cds[camId] then
        return false
    end
    cds[camId] = now + 3
    Player(src).state.camCooldowns = cds

    local paid = false
    local bank = xPlayer.getAccount('bank') and xPlayer.getAccount('bank').money or 0
    if bank >= amount then
        xPlayer.removeAccountMoney('bank', amount)
        paid = true
    elseif (xPlayer.getMoney() or 0) >= amount then
        xPlayer.removeMoney(amount)
        paid = true
    end
    
    -- lib.logger(src, 'speedCamera', ('%s – cam #%d – %dkm/u – €%d – %s'):format(
    --     xPlayer.getName(), camId, speed, amount, paid and 'paid' or 'billing'), 'default', src)

    return paid
end)
