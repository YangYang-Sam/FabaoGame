local Monster={}
Monster.__index=Monster

function Monster.new(x,y,radius,maxHealth, maxPhysicalShield, maxMagicShield, priority, isBoss)
    local self = setmetatable({}, Monster)
    self.x = x
    self.y = y 
    self.radius = radius
    self.maxHealth = maxHealth
    self.health = maxHealth
    self.maxPhysicalShield = maxPhysicalShield
    self.physicalShield = maxPhysicalShield
    self.maxMagicShield = maxMagicShield
    self.magicShield = maxMagicShield
    self.priority = priority or 10
    self.isBoss = isBoss or true
    self.isDead = false
    self.hit=false
    self.hitTimer=0
    self.damageTaken=0
    self.soulDamage=5
    return self
end

function Monster:takeDamage(damage, damageType)
    local initialHealth = self.health

    if damageType ==  'physical' and self.physicalShield > 0 then
        local remainingDamage = damage - self.physicalShield
        self.physicalShield = math.max(0, self.physicalShield - damage)
        if remainingDamage > 0 then
            self.health = math.max(0, self.health - remainingDamage)
        end
    elseif damageType == 'magic' and self.magicShield > 0 then
        local remainingDamage = damage - self.magicShield
        self.magicShield = math.max(0, self.magicShield - damage)
        if remainingDamage > 0 then
            self.health = math.max(0, self.health - remainingDamage)
        end
    else
        self.health = math.max(0, self.health - damage)
    end

    if self.health<initialHealth then
        self.damageTaken=self.damageTaken+initialHealth-self.health
    end

    self.hit=true
    self.hitTimer=0.1--受击效果持续时间
end

function Monster:checkBulletCollision(bullet)
    local distance = math.sqrt((self.x - bullet.x)^2 + (self.y - bullet.y)^2)
    return distance < self.radius + bullet.range
end

function Monster:checkGenerateSoul(soulList)
    while self.damageTaken>=self.soulDamage do
        self.damageTaken=self.damageTaken-self.soulDamage
        table.insert(soulList,soul.new(self.x,self.y,math.random(-20, 20), -100))
    end
end
--将伤害数值存在damageNumbers array中
function Monster:addDamageNumber(damageNumbers,bullet)
    local angle = math.random() * (2 * math.pi) -- 随机方向
    local speed = 50 + math.random() * 50 -- 随机速度
    table.insert(damageNumbers, {
        x = bullet.x,
        y = bullet.y,
        damage = bullet.damage,
        scale = 1,
        alpha = 1,
        timer = 0,
        dx = math.cos(angle) * speed,
        dy = math.sin(angle) * speed,
        gravity = 100
        })
end

function Monster:update(dt)
    if self.hit then
        self.hitTimer=self.hitTimer - dt
    if self.hitTimer<=0 then
            self.hit=false
        end
    end
end

function Monster:draw()
    if self.hit then
        love.graphics.setColor(1,0,0)
        local dx = math. random(-2,2)
        local dy = math. random(-2,2)
        love.graphics.circle('fill',self.x+dx,self.y+dy,self.radius)
    else
        love.graphics.setColor(1,1,0)
        love.graphics.circle('fill',self.x,self.y,self.radius)
    end

        --绘制物理护盾
    if self.physicalShield>0 then
        love.graphics.setColor(1,1,1)
        love.graphics.circle('line',self.x,self.y,self.radius+5)
    end

        --绘制魔法护盾
    if self.magicShield>0 then
        love.graphics.setColor(1,0,1)
        love.graphics.circle('line',self.x,self.y,self.radius+10)
    end
end

return Monster