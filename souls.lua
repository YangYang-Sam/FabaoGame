local souls = {}

function souls.new(x, y, dx, dy)
    return {
        x = x,
        y = y,
        dx = dx,
        dy = dy
    }
end

function souls.update(soul, dt)
    soul.x = soul.x + soul.dx * dt
    soul.y = soul.y + soul.dy * dt

    -- 随机漂浮
    soul.dx = soul.dx + math.random(-10, 10) * dt
    soul.dy = soul.dy + math.random(-10, 10) * dt

    -- 边界检测和反弹
    if soul.x < 0 then
        soul.x = 0
        soul.dx = -soul.dx
    elseif soul.x > love.graphics.getWidth() then
        soul.x = love.graphics.getWidth()
        soul.dx = -soul.dx
    end

    if soul.y < 0 then
        soul.y = 0
        soul.dy = -soul.dy
    elseif soul.y > love.graphics.getHeight() then
        soul.y = love.graphics.getHeight()
        soul.dy = -soul.dy
    end
end

function souls.draw(soul)
    love.graphics.circle("fill", soul.x, soul.y, 10)
end

return souls