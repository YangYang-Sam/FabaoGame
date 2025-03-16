local save = {}

local saveFilePath = "savefile.txt"

-- 保存怪物的血量
function save.saveMonsterHealth(monster)
    local file = love.filesystem.newFile(saveFilePath, "w")
    if file then
        file:write(tostring(monster.health))
        file:close()
    else
        print("Error: Could not open save file for writing.")
    end
end

-- 加载怪物的血量
function save.loadMonsterHealth(monster)
    if love.filesystem.getInfo(saveFilePath) then
        local file = love.filesystem.newFile(saveFilePath, "r")
        if file then
            local health = file:read()
            monster.health = tonumber(health)
            file:close()
        else
            print("Error: Could not open save file for reading.")
        end
    else
        print("No save file found.")
    end
end

return save