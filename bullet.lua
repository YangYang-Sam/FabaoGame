local Bullet = {}
Bullet.__index = Bullet

function Bullet.new(target,x, y, angle, speed, damage, range,effects,tracking,curveFactor,attribute,showImage,bulletImage)
    local self = setmetatable({}, Bullet)
    self.x = x
    self.y = y
    self.angle = angle
    self.speed = speed
    self.dx = math.cos(angle) * speed
    self.dy = math.sin(angle) * speed
    self.damage = damage
    self.range = range
    self.effects = effects or {}
    self.tracking = tracking or false
    self.curveFactor = curveFactor or 20
    self.attribute = attribute or 'physical'
    self.showImage = showImage or false
    self.bulletImage = love.graphics.newImage(bulletImage or "Feijian-blt.png")
    self.target = target or nil

    return self
end

function Bullet:update(dt)

    if self.target and not self.target.isDead then
        --更新子弹位置
        --print(self.target)
        self.x = self.x + self.dx * dt
        self.y = self.y + self.dy * dt

         --如果开启追踪功能，更新子弹方向
        if self.tracking then
            local targetAngle = math.atan2(self.target.y - self.y, self.target.x - self.x)
            local currentAngle = math.atan2(self.dy, self.dx)
            
            --计算新的方向
            local angleDifference = targetAngle - currentAngle
            if angleDifference > math.pi then
                angleDifference = angleDifference - 2 * math.pi
            elseif angleDifference < -math.pi then
                angleDifference = angleDifference + 2 * math.pi
            end

            local distance = math.sqrt((self.target.x - self.x)^2 + (self.target.y - self.y)^2)
            local adjustedCurveFactor = self.curveFactor * (1/distance)
            local newAngle = currentAngle + angleDifference * adjustedCurveFactor

            self.dx = math.cos(newAngle) * math.sqrt(self.dx^2 + self.dy^2)
            self.dy = math.sin(newAngle) * math.sqrt(self.dx^2 + self.dy^2)
        end
    else
        print('lose target')
    end


   
end

function Bullet:draw()
    if self.showImage then
        local scale =2 --设置缩放比例为2倍
        local angle =math.atan2(self.dy,self.dx)+math.pi/2 --更新子弹角度
        love.graphics.draw(self.bulletImage,self.x,self.y,angle,scale,scale,self.bulletImage:getWidth()/2,self.bulletImage:getHeight()/2)
    end 
end

return Bullet
