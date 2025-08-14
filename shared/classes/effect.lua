local M = {}
function M.flashEffect()
    SetTimecycleModifier('BarryFadeOut')
    SetTimecycleModifierStrength(1.0)
    Wait(200)
    ClearTimecycleModifier()
end
return M
