require("scripts.core.shortcuts")
require("scripts.core.constants")

local main = {}


main.scripts = {}

function GAME()
    return main
end

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
    ui = require("scripts.core.ui"),
}

-- shortcut
main.log = function(msg, level)
    return main.core.logger.log(msg, level)
end

function love.load(args)
    main.core.threads.init()
    main.core.registry.init()
    main.core.physics.init()
    main.core.input.init()
    main.core.render.init()
    main.core.ui.init()
    -- main.core.filehelper.load_file("tests/file_io_test.lua")
    main.core.filehelper.load_file("tests/physics_test.lua")
    main.core.filehelper.load_file("tests/threads_test.lua")
end

function love.quit()
    main.core.logger.export()
end

local cur_dt = 0.0
local frame_delta = 1.0 / C_TICKS_PER_SECOND

function love.update(dt)
    main.core.threads.update()

    -- if cur_dt < frame_delta * 2 then 
    if dt < C_MAX_DELTA_ALLOWED then
        main.time = (main.time or 0) + dt
        main.ticks = math.floor(main.time * C_TICKS_PER_SECOND)
        main.core.ui.update(dt)
        main.core.render.update(dt)

        if main.core.threads.is_blocked() then 
            -- load screen logic
        else 
            -- logic update
            if main.core.world.is_active() then 
                main.core.world.update(dt)
            end
        end    
    end
end

-- Draw a coloured rectangle.
function love.draw()
    main.core.render.setup_frame()
    
    -- render game
    if main.core.world.is_active() then 
        main.core.world.render()
    end

    -- render ui
    main.core.ui.draw()

    -- render loading screen
    if main.core.threads.is_blocked() then 
        love.graphics.print("waiting on blocking thread...", 10, 200)
    end

    -- render loading icon
    if main.core.threads.has_background() then 
        love.graphics.print("waiting on blocking thread...", 10, 200)
    end

    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)
    love.graphics.print("Current blend: "..tostring(love.graphics.getBlendMode()), 10, 30)
end