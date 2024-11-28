require("scripts.core.constants")
local filehelper = {}

local encrypt_func = function(line)
    return line 
end

local decrypt_func = function(line)
    return line
end

-- attempt to convert the string into the primitive data type 
local format_key = function(key)
    return tonumber(key) or (key == "true" and true or key == "false" and false) or key
end

filehelper.init = function()
    love.filesystem.setIdentity(C_GAMENAME,true)
end

filehelper.serialize = function(object)
    if type(object) == "table" then 
        local ret = {}
        local ret_entry = C_FH_SERIAL_TABLE_START

        for key,val in pairs(object) do 
            ret_entry = ret_entry..key..C_FH_SERIAL_CONNECT
            local ret2 = filehelper.serialize(val)

            if type(ret2) == "table" then 
                for _,val2 in pairs(ret2) do 
                    ret_entry = ret_entry..val2..C_FH_SERIAL_DELIM
                end    
            else
                ret_entry = ret_entry..tostring(ret2)..C_FH_SERIAL_DELIM
            end
        end    

        return ret_entry..C_FH_SERIAL_TABLE_END
    else 
        return tostring(object)
    end
end

filehelper.deserialize = function(serialized) 
    if not serialized:find(C_FH_SERIAL_TABLE_START) and not serialized:find(C_FH_SERIAL_TABLE_END) then 
        return serialized:sub(1,serialized:len() - 1)
    end

    local ret = {}
    local working = serialized 
    if working:sub(1,1) == C_FH_SERIAL_TABLE_START then  --strip outer table brackets of complex objects
        working = working:sub(2,-2)
    end

    local depth = working:len() / 2

    while working:len() > 0 and depth > 0 do 
        local next_delim = math.min(working:find(C_FH_SERIAL_TABLE_START) or -1, working:find(C_FH_SERIAL_DELIM) or -1)
        local is_table = false 

        if next_delim == working:find(C_FH_SERIAL_TABLE_START) then 
            local start_delim = next_delim
            next_delim = working:find(C_FH_SERIAL_TABLE_END)

            -- grab nested tables 
            local next_start_delim = working:find(C_FH_SERIAL_TABLE_START, start_delim + 1)

            while start_delim and next_delim and next_start_delim and next_start_delim < next_delim do 
                start_delim = working:find(C_FH_SERIAL_TABLE_START, start_delim + 1)
                next_delim = working:find(C_FH_SERIAL_TABLE_END, next_delim + 1) or start_delim
                next_start_delim = working:find(C_FH_SERIAL_TABLE_START, start_delim + 1) or next_delim --find next internal table bracket (or end!)
            end

            next_delim = next_delim + 1
            is_table = true 
        end

        local next_str = working:sub(1,next_delim)
        local connect = next_str:find(C_FH_SERIAL_CONNECT)

        if connect ~= nil then 
            local k,v = next_str:sub(1,connect-1), next_str:sub(connect+1,next_str:len())

            if is_table then 
                ret[format_key(k)] = filehelper.deserialize(v)
            else
                local cur_val_ind = (v:find(C_FH_SERIAL_DELIM) or v:len())
                ret[format_key(k)] = v:sub(1, cur_val_ind - 1)
                next_delim = cur_val_ind + k:len() + 1
            end    
        end

        working = working:sub(next_delim+1, working:len())
        depth = depth - 1
    end

    return ret 
end

filehelper.write_file = function(filename, write_func, encrypted)
    -- love.filesystem.createDirectory(filename)
    local file = love.filesystem.newFile(filename)
    local ok, error = file:open("w")

    if not ok then 
        GAME().log(error)
        return ok, error 
    else
        local lines = write_func(file)

        if lines then 
            for _,line in ipairs(lines) do 
                file:write((encrypted == true and encrypt_func(line) or line).."\n")
            end    
        end
    
        file:close()    
        GAME().log("Wrote file \'"..love.filesystem.getRealDirectory(file:getFilename()).."/"..file:getFilename().."\'")

        return true 
    end
end

filehelper.load_file = function(file, execute)
    execute = execute == nil and true or execute
    local loaded = love.filesystem.load(file)

    if loaded ~= nil then 
        if execute then 
            loaded = loaded() 
        end

        insert(GAME().scripts, loaded)
        return loaded
    end 
end

filehelper.read_file = function(file)
    GAME().log("Read lines of file \'"..love.filesystem.getRealDirectory(file).."/"..file.."\'")
    return love.filesystem.lines(file)
end

return filehelper 