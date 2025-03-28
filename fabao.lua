local Fabao = {}
Fabao.__index = Fabao

function Fabao.new(fabaoId,fabaolv,bulletType, fireRate, bulletCount, durability, durabilityCost, bulletSpeed, bulletDamage, bulletRadius, bulletEffects, imagePath,bulletAttribute)
    local self = setmetatable({}, Fabao)
    self.x =200
    self.y =200
    self.speed = 200
    self.id=fabaoId
    self.lv=fabaolv
    self.bulletType = bulletType
    self.fireRate = fireRate
    self.bulletTimer = 0
    self.bulletCount = bulletCount or 1 -- 单次攻击时发射的子弹数
    self.durability = durability or 100 -- 耐久值
    self.maxDurability = durability or 100 -- 最大耐久值
    self.durabilityCost = durabilityCost or 1 -- 单次攻击时的耐久消耗值
    self.bulletSpeed = bulletSpeed or 300 -- 子弹速度
    self.bulletDamage = bulletDamage or 1 -- 子弹伤害
    self.bulletRadius = bulletRadius or 5 -- 子弹半径
    self.bulletEffects = bulletEffects or {} -- 子弹效果
    self.imagepath = love.graphics.newImage(imagePath or "Sword-base.png") -- 加载法宝图片
    self.bulletAttribute = bulletAttribute or "physical" -- 子弹属性，默认为物理属性
    self.target = nil
    self.bulletList = {}
    return self
end

function Fabao:findTarget()
    local target = nil
    for i, monster in ipairs(monsterList) do
        if not target or monster.priority > target.priority then
            target = monster
        end
    end
    return target
end

function Fabao:fireBullet(dt)
    local target = self:findTarget()
    if target then
        self.bulletTimer = self.bulletTimer + dt
        if self.bulletTimer >= self.fireRate and self.durability > 0 then
            self.bulletTimer = 0
            self.durability = self.durability - self.durabilityCost -- 消耗耐久值
            for i = 1, self.bulletCount do
                local angle
                if self.bulletType == "feijian" then
                    angle = math.random() * (2 * math.pi) -- 随机方向
                    table.insert(self.bulletList, bullet.new(
                        target, 
                        self.x, 
                        self.y, 
                        angle, 
                        self.bulletSpeed, 
                        self.bulletDamage, 
                        self.bulletRadius, 
                        self.bulletEffects, 
                        true,
                        20,
                        self.bulletAttribute,
                        true,
                        'Feijian-blt.png')) -- 创建跟踪子弹
                else
                    angle = math.atan2(target.y - self.y, target.x - self.x) -- 直接指向目标
                    table.insert(self.bulletList, bullet.new(
                        target, 
                        self.x, self.y, 
                        angle, 
                        self.bulletSpeed, 
                        self.bulletDamage, 
                        self.bulletRadius, 
                        self.bulletEffects, 
                        false, 
                        20, 
                        self.bulletAttribute, 
                        fasle,
                        'Jiguang-blt.png')) -- 创建非跟踪子弹
                end
            end


        end

       
    --target=self:findTarget()
    end
end

function Fabao:checkBulletCollision(bullet,monster)
    local distance = math.sqrt((monster.x - bullet.x)^2 + (monster.y - bullet.y)^2)
    return distance < monster.radius + bullet.range
end

function Fabao:update(dt)
    -- 移动法宝
    if love.keyboard.isDown("left") then
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown("right") then
        self.x = self.x + self.speed * dt
    end
    if love.keyboard.isDown("up") then
        self.y = self.y - self.speed * dt
    end
    if love.keyboard.isDown("down") then
        self.y = self.y + self.speed * dt
    end

    local target=self:findTarget()
    
    self:fireBullet(dt)

     -- 更新子弹
     for i = #self.bulletList, 1, -1 do
        local bullets = self.bulletList[i]
        if bullets.target==nil or bullets.target.isDead then
            bullets.target = self:findTarget()
        end
        bullets:update(dt)
        -- 检测子弹是否击中怪物
        if target then
            if target:checkBulletCollision(bullets) then
                --print('hit')
                table.remove(self.bulletList, i)
                target:takeDamage(bullets.damage, bullets.attribute)
                -- 检查是否需要生成新的灵魂
                target:checkGenerateSoul(soulList)

                -- 添加伤害数字
                target:addDamageNumber(damageNumbers, bullets)
            end
        else
            table.remove(self.bulletList,i)
        end
    end

    

end

function Fabao:draw()
    love.graphics.draw(self.imagepath, self.x, self.y, 0, 1, 1, self.imagepath:getWidth() / 2, self.imagepath:getHeight() / 2) -- 绘制法宝图片
    self:drawDurabilityBar() -- 绘制耐久值条
    self:drawFireRateBar() -- 绘制攻击间隔条

    for _, bullet in ipairs(self.bulletList) do
        bullet:draw()
    end
end

function Fabao:drawDurabilityBar()
    local barWidth = 200
    local barHeight = 20
    local barX = (love.graphics.getWidth() - barWidth) / 2
    local barY = love.graphics.getHeight() - barHeight - 10
    local durabilityRatio = self.durability / self.maxDurability

    love.graphics.setColor(0.5, 0.5, 0.5) -- 设置背景颜色为灰色
    love.graphics.rectangle("fill", barX, barY, barWidth, barHeight)

    love.graphics.setColor(0, 1, 0) -- 设置耐久值颜色为绿色
    love.graphics.rectangle("fill", barX, barY, barWidth * durabilityRatio, barHeight)

    love.graphics.setColor(1, 1, 1) -- 设置边框颜色为白色
    love.graphics.rectangle("line", barX, barY, barWidth, barHeight)
end

function Fabao:drawFireRateBar()
    local barWidth = 60
    local barHeight = 10
    local barX = self.x - barWidth / 2
    local barY = self.y + 40
    local fireRateRatio = math.min(self.bulletTimer / self.fireRate, 1) -- 确保 fireRateRatio 不超过 1

    love.graphics.setColor(0.5, 0.5, 0.5) -- 设置背景颜色为灰色
    love.graphics.rectangle("fill", barX, barY, barWidth, barHeight)

    love.graphics.setColor(1, 0.5, 0.5) -- 设置攻击间隔颜色为红色
    love.graphics.rectangle("fill", barX, barY, barWidth * fireRateRatio, barHeight)

    love.graphics.setColor(1, 1, 1) -- 设置边框颜色为白色
    love.graphics.rectangle("line", barX, barY, barWidth, barHeight)
end

return Fabao