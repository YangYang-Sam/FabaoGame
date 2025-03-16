local particles = {}

function particles.new(x, y)
    -- 创建一个小方块作为粒子图像
    local canvas = love.graphics.newCanvas(10, 10)
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, 0, 5, 5)
    love.graphics.setCanvas()

    local particleSystem = love.graphics.newParticleSystem(canvas, 100)
    particleSystem:setParticleLifetime(0.2, 1) -- 粒子的生命周期
    particleSystem:setEmissionRate(10) -- 粒子的发射速率
    particleSystem:setLinearAcceleration(0, 100, 0, 200) -- 粒子的线性加速度
    particleSystem:setSpeed(-50, 50) -- 粒子的速度
    particleSystem:setRotation(0, 2 * math.pi) -- 粒子的旋转
    particleSystem:setSizeVariation(1) -- 粒子的大小变化
    particleSystem:setSizes(1, 3) -- 粒子的大小
    particleSystem:setColors(1, 1, 1, 1, 1, 1, 1, 0) -- 粒子的颜色变化

    return {
        x = x,
        y = y,
        particleSystem = particleSystem
    }
end

function particles.update(particle, dt)
    particle.particleSystem:update(dt)
end

function particles.draw(particle)
    love.graphics.draw(particle.particleSystem, particle.x, particle.y)
end

function particles.emit(particle, num)
    particle.particleSystem:emit(num)
end

return particles