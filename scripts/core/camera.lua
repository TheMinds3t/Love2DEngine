local cam = {}

cam.default_updates = {}
cam.follow = function(cam, dt, targ_x, targ_y)
    local targ_dist = GAME().util.get_distance(cam.x,cam.y,targ_x,targ_y)

    if targ_dist > C_CAMERA_TARGET_FORGIVENESS then 
        cam.speed = math.min(C_CAMERA_MAX_SPEED, targ_dist)
        cam.x = cam.x + (targ_x - cam.x) * cam.speed * dt
        cam.y = cam.y + (targ_y - cam.y) * cam.speed * dt    
    end
end

cam.init = function()
    cam.default_updates[C_CAMERA_MOVEMENT_TYPE.NORMAL] = function(dt)
        if cam.cur_cam.params ~= nil and cam.cur_cam.params.target then 
            local targ_x = cam.cur_cam.params.target.x
            local targ_y = cam.cur_cam.params.target.y
            cam.follow(cam.cur_cam,dt,targ_x,targ_y)
        end
    end

    cam.default_updates[C_CAMERA_MOVEMENT_TYPE.FIXED] = function(dt)
        if cam.cur_cam.params ~= nil and cam.cur_cam.params.target then 
            cam.cur_cam.x = cam.cur_cam.params.target.x or cam.cur_cam.x
            cam.cur_cam.y = cam.cur_cam.params.target.y or cam.cur_cam.y    
        end
    end    
    
    cam.default_updates[C_CAMERA_MOVEMENT_TYPE.NORMAL_CURSOR] = function(dt)
        if cam.cur_cam.params ~= nil and cam.cur_cam.params.target then 
            local x,y,w,h = cam.get_camera_viewport()
            local mouse_pos = cam.get_position_in_cam(GAME().input.mouse_x or 0, GAME().input.mouse_y or 0, true)

            local targ_x = cam.cur_cam.params.target.x + ((mouse_pos.x or C_WINDOW_DIMENSIONS.WIDTH / 2.0) - C_WINDOW_DIMENSIONS.WIDTH / 2.0) * C_CAMERA_MOUSE_CAPTURE_SCALAR
            local targ_y = cam.cur_cam.params.target.y + ((mouse_pos.y or C_WINDOW_DIMENSIONS.HEIGHT / 2.0) - C_WINDOW_DIMENSIONS.HEIGHT / 2.0) * C_CAMERA_MOUSE_CAPTURE_SCALAR
            cam.follow(cam.cur_cam,dt,targ_x,targ_y)
        end
    end    
end

cam.create_cam = function(movement_type, params)
    params = params == nil and {} or params
    cam.cur_cam = {}
    cam.cur_cam.x = C_WINDOW_DIMENSIONS.WIDTH / 2.0
    cam.cur_cam.y = C_WINDOW_DIMENSIONS.HEIGHT / 2.0
    cam.cur_cam.move_type = movement_type 
    cam.cur_cam.params = params
    cam.cur_cam.update = cam.default_updates[movement_type]
    return cam.cur_cam 
end

cam.update = function(dt)
    if cam.is_active() then 
        cam.cur_cam.update(dt)
    end
end

cam.apply_cam_transforms = function()
    if cam.is_active() then 
        love.graphics.translate(-cam.cur_cam.x + C_WINDOW_DIMENSIONS.WIDTH / 2.0, -cam.cur_cam.y + C_WINDOW_DIMENSIONS.HEIGHT / 2.0)
    end
end

cam.undo_cam_transforms = function()
    if cam.is_active() then 
        love.graphics.translate(cam.cur_cam.x - C_WINDOW_DIMENSIONS.WIDTH / 2.0, cam.cur_cam.y - C_WINDOW_DIMENSIONS.HEIGHT / 2.0)
    end
end

cam.is_active = function()
    return cam.cur_cam
end

cam.get_camera_viewport = function()
    if cam.is_active() then 
        return {
            x = cam.cur_cam.x - C_WINDOW_DIMENSIONS.WIDTH / 2.0,
            y = cam.cur_cam.y - C_WINDOW_DIMENSIONS.HEIGHT / 2.0,
            width = C_WINDOW_DIMENSIONS.WIDTH,
            height = C_WINDOW_DIMENSIONS.HEIGHT
        }
    else 
        return nil 
    end
end

cam.get_position_in_cam = function(x_pos,y_pos,screen_space)
    if cam.is_active() then 
        if screen_space then 
            local sx,sy,ox,oy = GAME().ui.get_window_scale()
            return {
                x = math.min(C_WINDOW_DIMENSIONS.WIDTH, math.max(0, x_pos / sx - ox / 2.0 / sx)),
                y = math.min(C_WINDOW_DIMENSIONS.HEIGHT, math.max(0, y_pos / sy - oy / 2.0 / sy)),
            }
        else 
            return {
                x= x_pos - cam.cur_cam.x + C_WINDOW_DIMENSIONS.WIDTH / 2.0,
                y= y_pos - cam.cur_cam.y + C_WINDOW_DIMENSIONS.HEIGHT / 2.0,
            }    
        end
    else
        return nil 
    end
end

return cam