local CONST    = require('shared/const')
local Config   = require('shared/config')
local Effects  = require('shared/classes/effect')

local SpeedCamera   = {}
SpeedCamera.__index = SpeedCamera

local GetPedInVehicleSeat, GetEntitySpeed, GetGameTimer = GetPedInVehicleSeat, GetEntitySpeed, GetGameTimer

function SpeedCamera:new(id, data)
    local self = setmetatable({}, SpeedCamera)

    self.id        = id
    self.coords    = data.Coords
    self.maxSpeed  = data.MaxSpeed
    self.notify    = data.Notify ~= false
    self.radius    = data.Radius or 40.0
    self._cooldown = 0

    self:_registerPoint()
    return self
end

function SpeedCamera:_registerPoint()
    self.point = lib.points.new({
        coords   = self.coords,
        distance = self.radius,
        onEnter  = function() end,
        nearby   = function(point) self:_onNearby(point) end,
    })
end

function SpeedCamera:_onNearby(point)
    local ped = cache.ped
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 or GetPedInVehicleSeat(veh, -1) ~= ped then return end
    if point.currentDistance > self.radius then return end

    local speed = math.floor(GetEntitySpeed(veh) * 3.6 + 0.5)
    if speed <= self.maxSpeed then return end
    if self:isWhitelisted() then return end

    local now = GetGameTimer()
    if now < self._cooldown then return end
    self._cooldown = now + CONST.COOLDOWN_MS

    self:_triggerFlash(speed)
end

function SpeedCamera:_triggerFlash(speed)
    Effects.flashEffect()

    local paid = lib.callback.await('sliss_speedcams:flash', false, self.id, speed)
    local fine = (speed - self.maxSpeed) * CONST.PRICE_PER_KMH

    if paid then
        lib.notify({ title = 'SpeedCamera', description = 'The fine has been paid automatically.', type = 'success' })
    else
        -- BILLING EXPORT
    end

    if self.notify then
        lib.notify({
            title       = 'SpeedCamera',
            description = ('Your speed was %d km/h. Fine: €%d'):format(speed, fine),
            type        = 'error'
        })
    end
end

function SpeedCamera:isWhitelisted()
    local st  = LocalPlayer.state
    local job1, job2 = st.job and st.job.name, st.job2 and st.job2.name
    for _, allowed in ipairs(Config.WhitelistedJob) do
        if job1 == allowed or job2 == allowed then
            return true
        end
    end
    return false
end

return SpeedCamera