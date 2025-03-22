local monster = {}

function monster.new(x, y, radius, maxHealth, physicalShield, magicShield, priority, monsterType)
    return {
        x = x,
        y = y,
        radius = radius,
        maxHealth = maxHealth,
        health = maxHealth,
        physicalShield = physicalShield or 0, -- 物理护盾
        maxPShield=physicalShield,
        magicShield = magicShield or 0, -- 魔法护盾
        maxMShield=magicShield,
        hit = false,
        hitTimer = 0,
        damageTaken = 0, -- 记录怪物受到的伤害
        soulDamage = 5, -- 生成灵魂所需伤害
        priority = priority or 10, -- 优先级
        monsterType = monsterType or "normal" -- 怪物类型
    }
end

function monster.takeDamage(monster, damage, damageType)
    local initialHealth = monster.health

    if damageType == "physical" and monster.physicalShield > 0 then
        local remainingDamage = damage - monster.physicalShield
        monster.physicalShield = math.max(monster.physicalShield - damage, 0)
        if remainingDamage > 0 then
            monster.health = monster.health - remainingDamage
        end
    elseif damageType == "magic" and monster.magicShield > 0 then
        local remainingDamage = damage - monster.magicShield
        monster.magicShield = math.max(monster.magicShield - damage, 0)
        if remainingDamage > 0 then
            monster.health = monster.health - remainingDamage
        end
    else
        monster.health = monster.health - damage
    end

    if monster.health < initialHealth then
        monster.damageTaken = monster.damageTaken + (initialHealth - monster.health)
    end

    monster.hit = true
    monster.hitTimer = 0.1 -- 受击效果持续时间
end

function monster.checkBulletCollision(monster, bullet)
    local dist = math.sqrt((bullet.x - monster.x)^2 + (bullet.y - monster.y)^2)
    return dist < monster.radius
end

function monster.checkGenerateSoul(monster, soulList, souls)
    while monster.damageTaken >= monster.soulDamage do
        monster.damageTaken = monster.damageTaken - monster.soulDamage -- 重置计数器
        table.insert(soulList, souls.new(monster.x, monster.y, math.random(-20, 20), -100))
    end
end

function monster.addDamageNumber(damageNumbers, bullet)
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

function monster.update(monster, dt)
    if monster.hit then
        monster.hitTimer = monster.hitTimer - dt
        if monster.hitTimer <= 0 then
            monster.hit = false
        end
    end
end

function monster.draw(monster)
    if monster.hit then
        love.graphics.setColor(1, 0, 0) -- 受击时颜色为红色
        local dx = math.random(-2, 2)
        local dy = math.random(-2, 2)
        love.graphics.circle("fill", monster.x + dx, monster.y + dy, monster.radius) -- 绘制震动的目标点
    else
        love.graphics.setColor(1, 1, 0) -- 正常颜色为黄色
        love.graphics.circle("fill", monster.x, monster.y, monster.radius) -- 绘制目标点
    end

    -- 绘制物理护盾
    if monster.physicalShield > 0 then
        love.graphics.setColor(1, 1, 1) -- 物理护盾颜色为白色
        love.graphics.circle("line", monster.x, monster.y, monster.radius + 5)
    end

    -- 绘制魔法护盾
    if monster.magicShield > 0 then
        love.graphics.setColor(1, 0, 1) -- 魔法护盾颜色为紫色
        love.graphics.circle("line", monster.x, monster.y, monster.radius + 10)
    end
end

return monster