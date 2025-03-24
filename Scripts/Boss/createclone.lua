local CreateClone = {}
CreateClone.__index = CreateClone

CreateClone.amount = 10

function CreateClone.new(parent)
    local self = setmetatable({}, CreateClone)
    self.parent = parent
    self.x = parent.x
    self.y = parent.y
    self.clonelist = {}
    self.cooldown = 5
    self.timer = 5
    self.angle = 0

    return self
end

function CreateClone:spawnClone()
    local i = self.amount
    while i > 0 do
        local clone = monster.new(self.x, self.y, 10, 1, 0, 0, 20, false)
        i= i - 1
        table.insert(self.clonelist, clone)
    end
end

function CreateClone:removeClone()
    for i, clone in ipairs(self.clonelist) do
        if clone.isDead then
            table.remove(self.clonelist, i)
        end
    end
end

function CreateClone:update(dt)

    if self.timer > 0 then
        self.timer = self.timer - dt
    else
        self:spawnClone()
        self.timer = self.cooldown
    end
end

return CreateClone