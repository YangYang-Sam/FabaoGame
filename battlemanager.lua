local battleManager = {}

local lFabao
fabaoData={}
local bulletList = {}
local target
local screenShake = { duration = 0, intensity = 0 }
local damageNumbers = {}
local soulList = {}
local collectedSouls = 0
local clickRadius = 30
local clickX, clickY = nil, nil
local clickTime = 0
local itemX,itemY=250,200 --显示区域的大小

local buttons = {}
local currentFabao = 1

-- 从 CSV 文件加载 Fabao 数据
function  getFabaoData()
    local file = io.open("fabao_data.csv", "r")
    if not file then
        return nil, "Failed to open file. "
    end
    
    local isFirstLine = true --排除第一行
    for line in file:lines() do
        if isFirstLine then
            isFirstLine = false
        else
            local row = {}
            for value in line:gmatch("([^,]+)") do
                table.insert(row, value)
            end
            local f = fabao.new(tonumber(row[1]),tonumber(row[2]),row[3], tonumber(row[4]), tonumber(row[5]), tonumber(row[6]), tonumber(row[7]), tonumber(row[8]), tonumber(row[9]), tonumber(row[10]), {row[11]}, row[12], row[13])
            table.insert(fabaoData, f)
        end
    end
    --print(#fabaoData)
    return fabaoData
    
end

function createButton()
    for i, fabao in ipairs(fabaoData) do
        fabao = fabaoData[i]
        local iconX = 10 + ((i - 1) % 4) * 60
        local iconY = love.graphics.getHeight() - itemY + 10 + math.floor((i - 1) / 4) * 60
        local buttonImage = fabao.imagepath
        local button = button.new(buttonImage, iconX, iconY, 50, 50, function()
            currentFabao = i
        end)
        table.insert(buttons, button)
    end
end

function battleManager.load()
    -- 初始化 Fabao
    getFabaoData()

    
    lFabao = fabaoData[currentFabao]

    if lFabao == nil then
        print("fabao is nil")
        lFabao = fabao.new(200, "feijian", 0.8, 3, 100, 1, 300, 1, 5, {"fire"}, "physical")        
    end

    -- 创建按钮
    createButton()

    target = monster.new(600, 300, 30, 10000, 0, 50, 10, true) -- 创建一个带有物理护盾和魔法护盾的怪物
    print(target)
    -- 加载怪物的血量
    save.loadMonsterHealth(target)
end

function battleManager.update(dt)
    -- 更新 Fabao
    lFabao:update(dt, bulletList, target)

    -- 更新子弹
    for i = #bulletList, 1, -1 do
        local bullets = bulletList[i]
        bullets:update(dt, target)

        -- 检测子弹是否击中怪物
        if target:checkBulletCollision(bullets) then
            table.remove(bulletList, i)
            target:takeDamage(bullets.damage, bullets.attribute)
            --print(bullets.attribute)
            screenShake.duration = 0.05 -- 屏幕震动持续时间
            screenShake.intensity = 2 -- 屏幕震动强度

            -- 检查是否需要生成新的灵魂
            target:checkGenerateSoul(soulList)

            -- 添加伤害数字
            target:addDamageNumber(damageNumbers, bullets)
        end
    end

    -- 更新怪物受击效果
    target:update(dt)

    -- 更新屏幕震动
    if screenShake.duration > 0 then
        screenShake.duration = screenShake.duration - dt
    end

    -- 更新伤害数字
    for i = #damageNumbers, 1, -1 do
        local dmg = damageNumbers[i]
        dmg.timer = dmg.timer + dt
        dmg.dx = dmg.dx or 0
        dmg.x = dmg.x + dmg.dx * dt
        dmg.y = dmg.y + dmg.dy * dt
        dmg.dy = dmg.dy + dmg.gravity * dt -- 应用重力
        dmg.scale = dmg.scale + 0.5 * dt -- 伤害数字放大
        dmg.alpha = dmg.alpha - 0.5 * dt -- 伤害数字淡出

        if dmg.alpha <= 0 then
            table.remove(damageNumbers, i)
        end
    end

    -- 更新灵魂位置
    for i = #soulList, 1, -1 do
        local soul = soulList[i]
        soul:update(dt)
    end

    -- 检查点击时间是否超过阈值
    if clickTime > 0 then
        clickTime = clickTime - dt
        if clickTime <= 0 then
            clickX, clickY = nil, nil
        end
    end

    -- 更新按钮
    for _, button in ipairs(buttons) do
        button:update(dt)
    end
    --更新法宝
    lFabao = fabaoData[currentFabao]

end

function battleManager.mousepressed(x, y, button, istouch, presses)
    --判断是否点击在显示区域内
    local isClickInItem = x<itemX and y>love.graphics.getHeight()-itemY

    if button == 1 and not isClickInItem then -- 左键点击
        clickX, clickY = x, y -- 记录点击位置
        clickTime = 0.5 -- 设置点击显示时间为0.5秒
        for i = #soulList, 1, -1 do
            local s = soulList[i]
            local dist = math.sqrt((x - s.x)^2 + (y - s.y)^2)
            if dist < clickRadius then -- 点击到灵魂
                collectedSouls = collectedSouls + s.weight
                table.remove(soulList, i)
                
            end
        end
    end
    --按钮点击事件
    for _, btn in ipairs(buttons) do
        btn:mousepressed(x, y, button)
    end

end

function battleManager.keypressed(key)

end

function battleManager.saveGame()
    save.saveMonsterHealth(target)
end



function battleManager.draw()
    -- 绘制 Fabao
    lFabao:draw()
    lFabao:drawDurabilityBar()
    lFabao:drawFireRateBar()

    -- 绘制子弹
    for i, bullets in ipairs(bulletList) do
        bullets:draw()
    end

    -- 绘制目标点（怪物）
    target:draw()

    -- 绘制怪物血条
    love.graphics.setColor(1, 0, 0) -- 设置颜色为红色
    love.graphics.rectangle("fill", love.graphics.getWidth() - 210, 10, 200 * (target.health / target.maxHealth), 20) -- 绘制血条
    love.graphics.setColor(1, 1, 1) -- 设置颜色为白色
    love.graphics.rectangle("line", love.graphics.getWidth() - 210, 10, 200, 20) -- 绘制血条边框
    love.graphics.print("Health: " .. target.health .. "/" .. target.maxHealth, love.graphics.getWidth() - 210, 35) -- 绘制血量数值

    -- 绘制物理护盾血条
    love.graphics.setColor(0, 0, 1) -- 设置颜色为蓝色
    love.graphics.rectangle("fill", love.graphics.getWidth() - 210, 80, 200 * (target.physicalShield / target.maxPhysicalShield), 10) -- 绘制物理护盾血条
    love.graphics.setColor(1, 1, 1) -- 设置颜色为白色
    love.graphics.rectangle("line", love.graphics.getWidth() - 210, 80, 200, 10) -- 绘制物理护盾血条边框
    love.graphics.print("Physical Shield: " .. target.physicalShield, love.graphics.getWidth() - 210, 100) -- 绘制物理护盾数值

    -- 绘制魔法护盾血条
    love.graphics.setColor(1, 0, 1) -- 设置颜色为紫色
    love.graphics.rectangle("fill", love.graphics.getWidth() - 210, 150, 200 * (target.magicShield / target.maxMagicShield), 10) -- 绘制魔法护盾血条
    love.graphics.setColor(1, 1, 1) -- 设置颜色为白色
    love.graphics.rectangle("line", love.graphics.getWidth() - 210, 150, 200, 10) -- 绘制魔法护盾血条边框
    love.graphics.print("Magic Shield: " .. target.magicShield, love.graphics.getWidth() - 210, 170) -- 绘制魔法护盾数值

    -- 绘制伤害数字
    for i, dmg in ipairs(damageNumbers) do
        love.graphics.setColor(1, 1, 1, dmg.alpha) -- 设置颜色为白色，透明度随时间变化
        love.graphics.print(dmg.damage, dmg.x, dmg.y, 0, dmg.scale, dmg.scale)
    end

    -- 绘制灵魂
    if soulList[1] then
        for i, souls in ipairs(soulList) do
            souls:draw()
        end
    end

    -- 绘制收集的灵魂数目
    love.graphics.setColor(1, 1, 1) -- 设置颜色为白色
    love.graphics.print("Collected Souls: " .. collectedSouls, 10, 10)

    -- 绘制点击范围
    --if clickX and clickY then
        --love.graphics.setColor(1, 0, 0, 0.5) -- 设置颜色为半透明红色
        --love.graphics.circle("line", clickX, clickY, clickRadius)
    --end

    --绘制显示区域
    love.graphics.setColor(1, 1, 1) -- 设置颜色为白色
    love.graphics.rectangle("line",0,love.graphics.getHeight()-itemY,itemX,itemY)
    --显示鼠标坐标
    love.graphics.print("x:"..love.mouse.getX().." y:"..love.mouse.getY(),10,love.graphics.getHeight()-20)

    -- 绘制按钮
    for _, button in ipairs(buttons) do
        button:draw()
    end
end

return battleManager