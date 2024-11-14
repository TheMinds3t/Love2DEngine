require("scripts.core.shortcuts")
local logger = {}
logger.cur_log = {}
logger.cur_level = C_LOGGER_LEVELS.INFO

logger.log = function(msg, level)
    level = level == nil and C_LOGGER_LEVELS.DEBUG or level
    insert(logger.cur_log, "["..#logger.cur_log.."] "..tostring(msg))

    if logger.cur_level <= level then 
        print(logger.cur_log[#logger.cur_log])
    end 
end

logger.export = function(logname)
    logname = logname == nil and C_LOGGER_LOG_FOLDER.."latest.txt" or C_LOGGER_LOG_FOLDER..logname
    love.filesystem.createDirectory(C_LOGGER_LOG_FOLDER)

    GAME().core.filehelper.write_file(logname, function()
        local lines = {}
        for i,line in ipairs(logger.cur_log) do 
            insert(lines, line)
        end
        
        return lines
    end, false)
end

return logger