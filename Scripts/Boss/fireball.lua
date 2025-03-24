local Fireball = {}
Fireball.__index = Fireball

function Fireball.new(parent)
    local self = setmetatable({}, Fireball)
    self.cooldown = 2
    self.timer = 0
    self.parent = parent
    return self
end

function Fireball:update(dt)
    self.timer = self.timer - dt
    if self.timer <= 0 then
        self:cast()
        self.timer = self.cooldown
    end
end

function Fireball:cast()
    -- 施放火球技能的逻辑
    print("Monster at (" .. self.parent.x .. ", " .. self.parent.y .. ") casts Fireball!")
end

function Fireball:draw()
   
end

return Fireball