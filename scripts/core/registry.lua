require("scripts.core.shortcuts")
require("scripts.core.constants")
local registry = {}

registry.init = function()
    local files = love.filesystem.getDirectoryItems(C_REG_FOLDER)
    registry.active = {}

    for _,file in ipairs(files) do 
        if love.filesystem.getInfo(C_REG_FOLDER..file,"file") then 
            local reg_key = file:sub(1,(file:find(".",1,true) - 1 or file:len()))
            registry.active[reg_key] = GAME().filehelper.load_file(C_REG_FOLDER..file)
            GAME().log("New register \'"..reg_key.."\' initialized!", C_LOGGER_LEVELS.CORE)    
        end
    end
end

registry.get_registry_object = function(reg_id, id)
    local reg = registry.active[reg_id]

    if reg then 
        local data = reg.entries[id]
        if data then 
            if reg.clone_on_create == true then 
                GAME().log("Created clone of entry \'"..id.."\' from register \'"..reg_id.."\'", C_LOGGER_LEVELS.DEBUG)
                return GAME().util.deep_copy(data)
            else
                GAME().log("Retrieved entry \'"..id.."\' from register \'"..reg_id.."\'", C_LOGGER_LEVELS.DEBUG)
                return data
            end
        else 
            GAME().log("Unable to construct entry \'"..id.."\' from register \'"..reg_id.."\'", C_LOGGER_LEVELS.CORE)
        end
    else 
        GAME().log("Unknown register \'"..reg_id.."\'", C_LOGGER_LEVELS.CORE)
    end
end

registry.get_keys_for = function(reg_id)
    local reg = registry.active[reg_id]

    if reg then 
        local data = reg.entries
        local ret = {}

        for key,_ in pairs(data) do 
            insert(ret, key)
        end

        return ret
    else 
        GAME().log("Unknown register \'"..reg_id.."\'", C_LOGGER_LEVELS.ERROR)
    end
end

return registry