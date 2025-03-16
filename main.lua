local particles = require("particles")
local save = require("save")
local battleManager = require("battlemanager")
local craftManager = require("craftmanager")

local gameState = "menu" -- 当前游戏状态，默认为菜单界面
local particleEffect -- 用于存储粒子效果

-- 解析 CSV 文件的函数
local function parseCSV(filePath)
    local file = io.open(filePath, "r")
    if not file then
        return nil, "Failed to open file."
    end

    local content = {}
    for line in file:lines() do
        local row = {}
        for value in line:gmatch("([^,]+)") do
            table.insert(row, value)
        end
        table.insert(content, row)
    end

    file:close()
    return content
end

function love.load()
    -- 初始化游戏状态
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1) -- 设置背景颜色

    -- 加载中文字体
    font1 = love.graphics.newFont("Fonts/Microsoft_YaHei_Bold.ttf", 20) -- 加载字体文件，字号为20
    font2 = love.graphics.newFont("Fonts/AlimamaFangYuanTiVF-Thin.ttf", 20) -- 加载字体文件，字号为30
    love.graphics.setFont(font2) -- 设置全局字体

    -- 初始化粒子效果
    particleEffect = particles.new(100, 100)

    -- 初始化战斗管理器并传递法宝数据
    battleManager.load()

    -- 初始化制作管理器并传递法宝数据
    craftManager.load()

end

function love.update(dt)
    if gameState == "game" then
        battleManager.update(dt)
    elseif gameState == "craft" then
        craftManager.update(dt)
    elseif gameState == "menu" then
        -- 更新粒子效果
        particles.update(particleEffect, dt)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then -- 左键点击
        if gameState == "menu" then
            if x < love.graphics.getWidth() / 2 then
                gameState = "craft" -- 切换到制作界面
            else
                gameState = "game" -- 切换到游戏界面
            end
        elseif gameState == "craft" then
            craftManager.mousepressed(x, y, button, istouch, presses)
        elseif gameState == "game" then
            battleManager.mousepressed(x, y, button, istouch, presses)
        end
    end
end

function love.keypressed(key)
    if gameState == "game" then
        battleManager.keypressed(key)
    elseif gameState == "craft" then
        craftManager.keypressed(key)
    end
end

function love.draw()
    if gameState == "menu" then
        -- 绘制菜单界面
        love.graphics.setColor(1, 1, 1) -- 设置颜色为白色
        love.graphics.printf("法宝 Simulator", 0, love.graphics.getHeight() / 2 - 20, love.graphics.getWidth(), "center")
        love.graphics.printf("点击屏幕左侧按钮进入制作界面，右侧按钮开始游戏", 0, love.graphics.getHeight() / 2 + 20, love.graphics.getWidth(), "center")
        -- 绘制粒子效果
        particles.draw(particleEffect)

    elseif gameState == "craft" then
        craftManager.draw()
    elseif gameState == "game" then
        battleManager.draw()
    end
end

function love.quit()
    if gameState == "game" then
        battleManager.saveGame()
    end
end