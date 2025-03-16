local bullets = {}

local bulletImage = love.graphics.newImage("Feijian-blt.png") -- 加载子弹图片
local curveFactor = 0.05 -- 转向速度系数
function bullets.new(x, y, angle, speed, damage, radius, effects, tracking, attribute)
    return {
        x = x,
        y = y,
        dx = math.cos(angle) * speed,
        dy = math.sin(angle) * speed,
        damage = damage,
        radius = radius,
        effects = effects or {},
        tracking = tracking or false, -- 是否开启追踪功能
        attribute = attribute or "physical", -- 子弹属性，默认为物理属性

    }
end

function bullets.update(bullet, dt, target)
    -- 更新子弹位置
    bullet.x = bullet.x + bullet.dx * dt
    bullet.y = bullet.y + bullet.dy * dt

    -- 如果开启追踪功能，更新子弹方向
    if bullet.tracking and target then
        local targetAngle = math.atan2(target.y - bullet.y, target.x - bullet.x)
        local currentAngle = math.atan2(bullet.dy, bullet.dx)
        
        -- 计算新的方向
        local newAngle = currentAngle + (targetAngle - currentAngle) * curveFactor -- 0.05 是调整转向速度的系数
        bullet.dx = math.cos(newAngle) * math.sqrt(bullet.dx^2 + bullet.dy^2)
        bullet.dy = math.sin(newAngle) * math.sqrt(bullet.dx^2 + bullet.dy^2)
    end
end

function bullets.draw(bullet)
    local scale = 2 -- 设置缩放比例为2倍
    local angle = math.atan2(bullet.dy, bullet.dx)+ math.pi / 2 -- 计算子弹的旋转角度
    love.graphics.draw(bulletImage, bullet.x, bullet.y, angle, scale, scale, bulletImage:getWidth() / 2, bulletImage:getHeight() / 2)
end

return bullets