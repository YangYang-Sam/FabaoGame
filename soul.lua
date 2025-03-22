local Soul ={}
Soul.__index = Soul

function Soul.new(x, y, dx, dy)
    local self = setmetatable({}, Soul)
    self.x=x
    self.y=y
    self.dx=dx or 1
    self.dy=dy or 1
    self.weight=1
    return self
end

function Soul:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    --随机漂浮
    self.dx=self.dx+math.random(-10,10)*dt
    self.dy=self.dy+math.random(-10,10)*dt

    --边界检查和反弹
    if self.x<0 then
        self.x=0
        self.dx=-self.dx
    elseif self.x>love.graphics.getWidth() then
        self.x=love.graphics.getWidth()
        self.dx=-self.dx
    end

    if self.y<0 then
        self.y=0
        self.dy=-self.dy
    elseif self.y>love.graphics.getHeight() then
        self.y=love.graphics.getHeight()
        self.dy=-self.dy
    end
end

function Soul:draw()
    love.graphics.setColor(0, 0, 1) -- 设置颜色为蓝色
    love.graphics.circle("fill", self.x, self.y, 10)
end

return Soul