local Effects = {}

Effects.screenShake = { duration = 0, intensity = 0 }

function Effects.startScreenShake(duration, intensity)
    Effects.screenShake.duration = duration
    Effects.screenShake.intensity = intensity
end

function Effects.updateScreenShake(dt)
    if Effects.screenShake.duration > 0 then
        Effects.screenShake.duration = Effects.screenShake.duration - dt
    end
end

function Effects.applyScreenShake()
    if Effects.screenShake.duration > 0 then
        local dx = math.random(-Effects.screenShake.intensity, Effects.screenShake.intensity)
        local dy = math.random(-Effects.screenShake.intensity, Effects.screenShake.intensity)
        love.graphics.translate(dx, dy)
    end
end

return Effects