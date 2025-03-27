local UI = {}

function UI.drawBossUI(boss)
    -- 绘制怪物血条
    love.graphics.setColor(1, 0, 0) -- 设置颜色为红色
    love.graphics.rectangle("fill", love.graphics.getWidth() - 210, 10, 200 * (boss.health / boss.maxHealth), 20) -- 绘制血条
    love.graphics.setColor(1, 1, 1) -- 设置颜色为白色
    love.graphics.rectangle("line", love.graphics.getWidth() - 210, 10, 200, 20) -- 绘制血条边框
    love.graphics.print("Health: " .. boss.health .. "/" .. boss.maxHealth, love.graphics.getWidth() - 210, 35) -- 绘制血量数值

    -- 绘制物理护盾血条
    love.graphics.setColor(0, 0, 1) -- 设置颜色为蓝色
    love.graphics.rectangle("fill", love.graphics.getWidth() - 210, 80, 200 * (boss.physicalShield / boss.maxPhysicalShield), 10) -- 绘制物理护盾血条
    love.graphics.setColor(1, 1, 1) -- 设置颜色为白色
    love.graphics.rectangle("line", love.graphics.getWidth() - 210, 80, 200, 10) -- 绘制物理护盾血条边框
    love.graphics.print("Physical Shield: " .. boss.physicalShield, love.graphics.getWidth() - 210, 100) -- 绘制物理护盾数值

    -- 绘制魔法护盾血条
    love.graphics.setColor(1, 0, 1) -- 设置颜色为紫色
    love.graphics.rectangle("fill", love.graphics.getWidth() - 210, 150, 200 * (boss.magicShield / boss.maxMagicShield), 10) -- 绘制魔法护盾血条
    love.graphics.setColor(1, 1, 1) -- 设置颜色为白色
    love.graphics.rectangle("line", love.graphics.getWidth() - 210, 150, 200, 10) -- 绘制魔法护盾血条边框
    love.graphics.print("Magic Shield: " .. boss.magicShield, love.graphics.getWidth() - 210, 170) -- 绘制魔法护盾数值
end

function UI.drawFabaoUI(lFabao)
    -- 绘制 Fabao
    lFabao:draw()
    lFabao:drawDurabilityBar()
    lFabao:drawFireRateBar()
end

function UI.drawDamageNumbers(damageNumbers)
    -- 绘制伤害数字
    for i, dmg in ipairs(damageNumbers) do
        love.graphics.setColor(1, 1, 1, dmg.alpha) -- 设置颜色为白色，透明度随时间变化
        love.graphics.print(dmg.damage, dmg.x, dmg.y, 0, dmg.scale, dmg.scale)
    end
end

function UI.drawCollectedSouls(collectedSouls)
    -- 绘制收集的灵魂数目
    love.graphics.setColor(1, 1, 1) -- 设置颜色为白色
    love.graphics.print("Collected Souls: " .. collectedSouls, 10, 10)
end

function UI.drawButtons(buttons)
    -- 绘制按钮
    for _, button in ipairs(buttons) do
        button:draw()
    end
end

function UI.drawClickRange(clickX, clickY, clickRadius)
    -- 绘制点击范围
    if clickX and clickY then
        love.graphics.setColor(1, 0, 0, 0.5) -- 设置颜色为半透明红色
        love.graphics.circle("line", clickX, clickY, clickRadius)
    end
end

function UI.drawMouseCoordinates()
    -- 显示鼠标坐标
    love.graphics.print("x:" .. love.mouse.getX() .. " y:" .. love.mouse.getY(), 10, love.graphics.getHeight() - 20)
end

function UI.drawDisplayArea(itemX, itemY)
    -- 绘制显示区域
    love.graphics.setColor(1, 1, 1) -- 设置颜色为白色
    love.graphics.rectangle("line", 0, love.graphics.getHeight() - itemY, itemX, itemY)
end

return UI