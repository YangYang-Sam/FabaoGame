local SkillManager = {}
SkillManager.__index = SkillManager

function SkillManager.new()
    local self = setmetatable({}, SkillManager)
    self.skills = {}
    return self
end

function SkillManager:loadSkill(skillName, parent)
    local skill = require("Scripts.Boss." .. skillName)
    --self.skills[skillName] = skill
    local skillinstance = skill.new(parent)
    return skillinstance
end

function SkillManager:getSkill(skillName)
    return self.skills[skillName]
end

return SkillManager