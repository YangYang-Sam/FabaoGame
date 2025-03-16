local Button = {}
Button.__index = Button

function Button.new(image, x, y, width, height, onClick)
    local self = setmetatable({}, Button)
    self.image = image
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.onClick = onClick
    self.hover = false
    return self
end

function Button:update(dt)
    local mx, my = love.mouse.getPosition()
    self.hover = mx > self.x and mx < self.x + self.width and my > self.y and my < self.y + self.height
end

function Button:draw()
    if self.hover then
        love.graphics.setColor(1, 1, 1, 0.7) -- 半透明效果
    else
        love.graphics.setColor(1, 1, 1, 1) -- 不透明
    end
    love.graphics.draw(self.image, self.x, self.y, 0, self.width / self.image:getWidth(), self.height / self.image:getHeight())
    love.graphics.setColor(1, 1, 1, 1) -- 重置颜色
end

function Button:mousepressed(x, y, button)
    if button == 1 and self.hover then
        self.onClick()
    end
end

return Button