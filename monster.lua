local Monster = {}
Monster.__index = Monster

--全局实体列表
monsterList ={}

function Monster.new(x, y, radius, maxHealth, maxPhysicalShield, maxMagicShield, priority, isBoss, skillNames)
    local self = setmetatable({}, Monster)
    self.x = x
    self.y = y
    self.dx = 0                 
    self.dy = 0
    self.angle = 0 
    self.radius = radius
    self.maxHealth = maxHealth
    self.health = maxHealth
    self.maxPhysicalShield = maxPhysicalShield
    self.physicalShield = maxPhysicalShield
    self.maxMagicShield = maxMagicShield
    self.magicShield = maxMagicShield
    self.priority = priority or 10
    self.isBoss = isBoss or false
    self.isDead = false
    self.hit = false
    self.hitTimer = 0
    self.damageTaken = 0
    self.soulDamage = 5
    self.skills = {}

    -- 加载技能
    for _, skillName in ipairs(skillNames or {}) do
        local skill = skillManager:loadSkill(skillName, self)    
        table.insert(self.skills, skill)
    end

    -- 将怪物加入全局实体列表
    table.insert(monsterList, self)

    return self
end

function Monster:takeDamage(damage, damageType)
    local initialHealth = self.health

    if damageType == 'physical' and self.physicalShield > 0 then
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

    if self.health < initialHealth then
        self.damageTaken = self.damageTaken + initialHealth - self.health
    end

    self.hit = true
    self.hitTimer = 0.1 -- 受击效果持续时间
end

function Monster:checkBulletCollision(bullet)
    local distance = math.sqrt((self.x - bullet.x)^2 + (self.y - bullet.y)^2)
    return distance < self.radius + bullet.range
end

function Monster:checkGenerateSoul(soulList)
    while self.damageTaken >= self.soulDamage do
        self.damageTaken = self.damageTaken - self.soulDamage
        table.insert(soulList, soul.new(self.x, self.y, math.random(-20, 20), -100))
    end
end

-- 将伤害数值存在 damageNumbers array 中
function Monster:addDamageNumber(damageNumbers, bullet)
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

function Monster:circleAnimation(dt)
    if not self.isBoss then
        for _, monster in ipairs(monsterList) do
            if monster.isBoss then
                if not self.initialized then
                    self.angle = math.random() * (2 * math.pi) -- Random initial angle
                    self.initialized = true
                end
                self.angle = self.angle + dt -- Increment the angle over time
                local radius = 100
                self.x = monster.x + radius * math.cos(self.angle)
                self.y = monster.y + radius * math.sin(self.angle)
            end
        end   
    end
end

function Monster:update(dt)

    -- 更新受击效果
    if self.hit then
        self.hitTimer = self.hitTimer - dt
        if self.hitTimer <= 0 then
            self.hit = false
        end
    end

    -- 执行技能逻辑
    for _, skill in ipairs(self.skills) do
        skill:update(dt)
    end

    -- 检查怪物是否死亡
    if self.health then
        if self.health <= 0 then
            self.isDead = true
            -- 找到怪物在 monsterList 中的索引
            for i, monster in ipairs(monsterList) do
                if monster == self then
                    table.remove(monsterList, i)
                    break
                end
            end
        end
    end

    self:circleAnimation(dt)

end

function Monster:draw()
    if self.isBoss then
        if self.hit then
            love.graphics.setColor(1, 0, 0)
            local dx = math.random(-2, 2)
            local dy = math.random(-2, 2)
            love.graphics.circle('fill', self.x + dx, self.y + dy, self.radius)
            effects.startScreenShake(0.05,1)--屏幕震动
        else
            love.graphics.setColor(1, 1, 0)
            love.graphics.circle('fill', self.x, self.y, self.radius)
        end

        -- 绘制物理护盾
        if self.physicalShield > 0 then
            love.graphics.setColor(1, 1, 1)
            love.graphics.circle('line', self.x, self.y, self.radius + 5)
        end

        -- 绘制魔法护盾
        if self.magicShield > 0 then
            love.graphics.setColor(1, 0, 1)
            love.graphics.circle('line', self.x, self.y, self.radius + 10)
        end
    else
        love.graphics.setColor(0.2, 0.5, 1)
            love.graphics.circle('fill', self.x, self.y, self.radius)
    end

  
end

return Monster