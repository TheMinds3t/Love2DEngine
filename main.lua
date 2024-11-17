require("scripts.core.shortcuts")
require("scripts.core.constants")

local main = {}
main.core = {
    render = require("scripts.core.render"),
    threads = require("scripts.core.threads"),
    logger = require("scripts.core.logger"),
    filehelper = require("scripts.core.filehelper"),
    util = require("scripts.core.util"),
    physics = require("scripts.core.physics"),
    world = require("scripts.core.world"),
    registry = require("scripts.core.registry"),
    input = require("scripts.core.input"),
}

main.scripts = {}

function GAME()
    return main
end

-- shortcut
main.log = function(msg, level)
    return main.core.logger.log(msg, level)
end

function love.load(args)
    main.core.threads.init()
    main.core.registry.init()
    main.core.physics.init()
    main.core.input.init()
    -- main.core.filehelper.load_file("tests/file_io_test.lua")
    main.core.filehelper.load_file("tests/physics_test.lua")
    -- main.core.filehelper.load_file("tests/threads_test.lua")
end

function love.quit()
    main.core.logger.export()
end

local cur_dt = 0.0
local frame_delta = 1.0 / C_LOGIC_FRAME_RATE

function love.update(dt)
    cur_dt = cur_dt + dt 

    if cur_dt >= frame_delta then 
        -- tick!

        main.core.threads.update()

        if cur_dt < frame_delta * 2 then 
            if main.core.threads.is_blocked() then 
                -- load screen logic
            else 
                -- logic update
                if main.core.world.is_active() then 
                    main.core.world.update(dt)
                end
            end    

            cur_dt = cur_dt - frame_delta
        else 
            GAME().log("skip detected.. cur_dt="..cur_dt, C_LOGGER_LEVELS.DEBUG)
            
            while cur_dt >= frame_delta do 
                cur_dt = cur_dt - frame_delta
            end    
        end
    end
end

-- Draw a coloured rectangle.
function love.draw()
    love.graphics.clear()
    local delta_perc = cur_dt / frame_delta

    -- render game
    if main.core.world.is_active() then 
        main.core.world.render()
    end

    -- render ui

    -- render loading screen
    if main.core.threads.is_blocked() then 
        love.graphics.print("waiting on blocking thread...", 10, 200)
    end

    -- render loading icon
    if main.core.threads.has_background() then 
        love.graphics.print("waiting on blocking thread...", 10, 200)
    end

    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
    love.graphics.print("delta_perc: "..delta_perc, 10, 30)
end