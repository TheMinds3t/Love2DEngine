require("scripts.core.shortcuts")
local threads = {}

local blocking_threads = {}
local background_threads = {}
threads.get_blocking = function() return blocking_threads end 
threads.get_background = function() return background_threads end 

threads.blocking_messages = {}
threads.background_messages = {}

threads.init = function()
end

threads.is_blocked = function() return #blocking_threads > 0 end 

threads.has_background = function() return #background_threads > 0 end 


threads.add_blocking = function(filename)
    local new_thread = love.thread.newThread(filename)
    insert(blocking_threads, new_thread)
    new_thread:start()
end

threads.add_background = function(filename)
    insert(background_threads, love.thread.newThread(filename))
end

threads.update = function()
    for i=#blocking_threads, 1, -1 do
        local thread = blocking_threads[i] 
        local message = love.thread.getChannel(C_THREADS_BLOCKING_CHANNEL):pop()
        
        if message ~= nil then 
            insert(threads.blocking_messages, message)
        end

        if not thread:isRunning() then 
            remove(blocking_threads, i)
            thread:release()
        end
    end

    for i=#background_threads, 1, -1 do
        local thread = background_threads[i] 
        local message = love.thread.getChannel(C_THREADS_BACKGROUND_CHANNEL):pop()
        
        if message ~= nil then 
            insert(threads.background_messages, message)
        end

        if not thread:isRunning() then 
            remove(background_threads, i)
            thread:release()
        end
    end
end

return threads 