local Fabao = require("fabao")
local Button = require("button")

local craftManager = {}

local fabaoData = {}
local buttons = {}
local cancelButton

function craftManager.load(data)
    fabaoData = data or {}

    -- 创建按钮
    for i, fabao in ipairs(fabaoData) do
        local iconX = 50 + (i - 1) * 60
        local iconY = love.graphics.getHeight() / 2 - 30
        local buttonImage = love.graphics.newImage("Sword-base.png") -- 假设所有法宝使用相同的图标
        local button = Button.new(buttonImage, iconX, iconY, 50, 50, function()
            print("Clicked on fabao: " .. fabao[1])
        end)
        table.insert(buttons, button)
    end
    cancelButton = Button.new(love.graphics.newImage("cancel.png"), love.graphics.getWidth() - 50, 50, 32, 32, function()
        print("Clicked on cancel button")
    end)
end

function craftManager.update(dt)
    for _, button in ipairs(buttons) do
        button:update(dt)
    end
    cancelButton:update(dt)
end

function craftManager.mousepressed(x, y, button, istouch, presses)
    for _, btn in ipairs(buttons) do
        btn:mousepressed(x, y, button)
    end
    cancelButton:mousepressed(x, y, button)
end

function craftManager.keypressed(key)
    -- 处理制作界面的按键事件
end

function craftManager.draw()
    -- 绘制制作界面
    love.graphics.setColor(0, 1, 0) -- 设置颜色为绿色
    love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 - 100, 200, 200) -- 绘制绿色方块
    love.graphics.setColor(1, 1, 1) -- 设置颜色为白色
    love.graphics.printf("制作界面", 0, love.graphics.getHeight() / 2 + 120, love.graphics.getWidth(), "center")

    -- 绘制按钮
    for _, button in ipairs(buttons) do
        button:draw()
    end
    cancelButton:draw()
end

return craftManager