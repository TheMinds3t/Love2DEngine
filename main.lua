require("scripts.core.shortcuts")
require("scripts.core.constants")

local main = {}

main.scripts = {}

function GAME()
    return main
end

main.render = require("scripts.core.render")
main.threads = require("scripts.core.threads")
main.logger = require("scripts.core.logger")
main.filehelper = require("scripts.core.filehelper")
main.util = require("scripts.core.util")
main.physics = require("scripts.core.physics")
main.world = require("scripts.core.world")
main.registry = require("scripts.core.registry")
main.input = require("scripts.core.input")
main.ui = require("scripts.core.ui")
main.camera = require("scripts.core.camera")
main.audio = require("scripts.core.audio")
main.levelgen = require("scripts.core.levelgen")

-- init order
main.core = {
    main.logger,
    main.util,
    main.registry,
    main.filehelper,
    main.render,
    main.threads,
    main.physics,
    main.world,
    main.input,
    main.ui,
    main.camera,
    main.audio,
    main.levelgen
}

-- shortcut
main.log = function(msg, level)
    return main.logger.log(msg, level)
end

function love.load(args)
    for _,mod in ipairs(main.core) do 
        if mod and mod.init and not mod.inited then 
            mod.init()
            mod.inited = true
        end
    end

    main.core = nil

    -- main.filehelper.load_file("tests/file_io_test.lua")
    main.filehelper.load_file("tests/world_level_test.lua")
    -- main.filehelper.load_file("tests/physics_test.lua")
    -- main.filehelper.load_file("tests/threads_test.lua")
end

function love.quit()
    main.logger.export()
end

local cur_dt = 0.0
local frame_delta = 1.0 / C_TICKS_PER_SECOND

function love.update(dt)
    main.threads.update()
    main.audio.update(dt)

    -- if cur_dt < frame_delta * 2 then 
    if dt < C_MAX_DELTA_ALLOWED then
        main.time = (main.time or 0) + dt
        main.ticks = math.floor(main.time * C_TICKS_PER_SECOND)
        main.ui.update(dt)
        main.render.update(dt)

        if not main.threads.is_blocked() then 
            -- logic update
            if main.world.is_active() then 
                main.world.update(dt)
                main.camera.update(dt)
            end
        end    
    end
end

-- Draw a coloured rectangle.
function love.draw()
    local cam = main.camera.is_active()

    if cam then 
        main.camera.apply_cam_transforms()
    end
    
    main.render.setup_frame()

    -- render game
    if main.world.is_active() then 
        main.world.render()
    end

    if cam then 
        main.camera.undo_cam_transforms()
    end

    love.graphics.setCanvas()
    love.graphics.setColor(1,1,1,1)
    love.graphics.origin()
    love.graphics.push()
    local scaled_x, scaled_y, off_x, off_y = main.ui.get_window_scale(true)
    love.graphics.translate(off_x / 2.0, off_y / 2.0)
    love.graphics.scale(scaled_x, scaled_y)
    love.graphics.draw(main.render.canvas)
    love.graphics.pop()
    
    -- render ui
    main.ui.draw()

    -- render loading screen
    if main.threads.is_blocked() then 
        love.graphics.print("waiting on blocking thread...", 10, 200)
    end

    -- render loading icon
    if main.threads.has_background() then 
        love.graphics.print("waiting on background thread...", 10, 200)
    end

    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 10, 10)

    if cam then 
        local mouse_pos = GAME().camera.get_position_in_cam(GAME().input.mouse_x or 0, GAME().input.mouse_y or 0, true)
        love.graphics.print("Mouse Pos: "..GAME().util.round(mouse_pos.x)..","..GAME().util.round(mouse_pos.y), 10, 30)

        if cam.params.target then 
            local targ_pos = GAME().camera.get_position_in_cam(cam.params.target.x, cam.params.target.y)
            love.graphics.print("Target Pos: "..GAME().util.round(targ_pos.x)..","..GAME().util.round(targ_pos.y), 10, 50)    
        end
    end

    if main.world.players[1] and GAME().input.mouse_x and GAME().input.mouse_y then 
        local body = main.world.players[1].phys.body 
        local cam_pos = GAME().camera.get_position_in_cam(body:getX(),body:getY())
        local mouse_pos = GAME().camera.get_position_in_cam(GAME().input.mouse_x,GAME().input.mouse_y,true)
        local ang = GAME().util.get_angle_towards(cam_pos.x, cam_pos.y, mouse_pos.x, mouse_pos.y, true)
        love.graphics.print("Degree: "..ang, 10, 70)    
    end
end