require("scripts.core.constants")
local render = {}

render.anim_layer_states = {}
render.active_transform = nil 

render.reset_active = function()
    render.active_transform = love.math.newTransform(0,0,0,C_RENDER_ROOT_SPRITE_SCALE,C_RENDER_ROOT_SPRITE_SCALE)
end

render.reset_active()

render.init = function()
    for k,v in pairs(C_RENDER_LAYERS) do 
        render.anim_layer_states[v] = true
        GAME().log("render layer \'"..k.."\' = "..tostring(render.anim_layer_states[v]).."!")
    end

    local images = GAME().registry.get_keys_for(C_REG_TYPES.IMAGE)
    
    for _,img in ipairs(images) do 
        GAME().registry.get_registry_object(C_REG_TYPES.IMAGE, img):setFilter("nearest","nearest")
    end

    render.shader = love.graphics.newShader("resources/gfx/pixel_shader.c")
    love.graphics.setShader(render.shader)
    love.graphics.setBlendMode(C_RENDER_BLEND_MODES.ALPHA)
    render.shader:send("mult_col",{1,1,1,1})
    render.shader:send("add_col",{0,0,0,0})
    love.graphics.setDefaultFilter("nearest", "nearest")

    render.canvas = love.graphics.newCanvas(C_WINDOW_DIMENSIONS.WIDTH, C_WINDOW_DIMENSIONS.HEIGHT)
    render.canvas:setFilter("nearest","nearest")
    render.font = love.graphics.newFont("resources/gfx/font/bytten/font.ttf", C_FONT_SIZE_REGULAR)
    render.font:setFilter("linear","nearest", 2)
    render.font_height = render.font:getHeight()
    love.graphics.setFont(render.font)
end

render.get_layer_state = function(render_layer)
    return render.anim_layer_states[render_layer]
end

render.set_layer_state = function(render_layer, state)
    render.anim_layer_states[render_layer] = state
end

-- converts primitive data into complex data 
render.flush_anim_file = function(anim_obj)
    -- local anim_obj = GAME().registry.get_registry_object(C_REG_TYPES.ANIM_FILE, anim_id)

    if anim_obj.flushed ~= true then 
        local anims = anim_obj.animations

        for anim_name,anim in pairs(anims) do 
            local max_frame_time = 0
            anim.frames_indexed = {}
            local total_frames = #anim.frames
            for frame_ind,frame in ipairs(anim.frames) do 
                frame.index = frame_ind
                frame.image = GAME().registry.get_registry_object(C_REG_TYPES.IMAGE, frame.image)
                frame.dimensions = love.graphics.newQuad(
                    frame.dimensions.x, frame.dimensions.y,
                    frame.dimensions.w, frame.dimensions.h, 
                    frame.image:getPixelWidth(), frame.image:getPixelHeight())

                if not frame.color.r or not frame.color.g or not frame.color.b or not frame.color.a then 
                    frame.color.r = frame.color.r or 255
                    frame.color.g = frame.color.g or 255
                    frame.color.b = frame.color.b or 255
                    frame.color.a = frame.color.a or 255
                end

                max_frame_time = max_frame_time + frame.frames
            end

            anim.frame_time = max_frame_time
        end

        anim_obj.flushed = true 
    end

    return anim_obj
end

render.setup_frame = function()
    love.graphics.clear(0.5,0.5,0.5,1)
    love.graphics.setCanvas(render.canvas)
    love.graphics.clear(0,0,0,1)
end

render.create_sprite = function(reg_id)
    local sprite = GAME().registry.get_registry_object(C_REG_TYPES.SPRITE, reg_id)
    sprite.anim_path = sprite.anim_file
    sprite.anim_file = render.flush_anim_file(GAME().registry.get_registry_object(C_REG_TYPES.ANIM_FILE, sprite.anim_file))
    sprite.cur_anim = sprite.default_anim
    sprite.frame = 1
    sprite.frame_off = 0
    sprite.x = 0
    sprite.y = 0
    sprite.rot = 0
    sprite.event_frame = {}

    return sprite
end

render.create_mesh = function(img_id,w,h)
    local img = GAME().registry.get_registry_object(C_REG_TYPES.IMAGE, img_id)
    local mesh = {}
    mesh.x = 0
    mesh.y = 0
    mesh.width = w / C_RENDER_ROOT_SPRITE_SCALE
    mesh.height = h / C_RENDER_ROOT_SPRITE_SCALE
    mesh.rot = 0
    mesh.meshed = true 
    local u_width = w / img:getPixelWidth() / C_RENDER_ROOT_SPRITE_SCALE
    local v_width = h / img:getPixelHeight() / C_RENDER_ROOT_SPRITE_SCALE

    local points = {
        {0,0,0,0},
        {w / C_RENDER_ROOT_SPRITE_SCALE,0,u_width,0},
        {w / C_RENDER_ROOT_SPRITE_SCALE,h / C_RENDER_ROOT_SPRITE_SCALE,u_width,v_width},
        {0,h / C_RENDER_ROOT_SPRITE_SCALE,0,v_width},
    }

    mesh.mesh = love.graphics.newMesh(points,"fan","dynamic")
    mesh.mesh:setTexture(img)
    mesh.mesh:getTexture():setWrap(C_RENDER_TEXTURE_WRAPMODE,C_RENDER_TEXTURE_WRAPMODE)
    return mesh 
end

render.update = function(dt)
end

render.update_sprite = function(sprite, holder, dt)
    if not render.validate_sprite(sprite) then 
        return 
    end

    if holder then 
        local vx, vy = holder.phys.body:getLinearVelocity()
        sprite.x = holder.phys.body:getX() + vx / C_WORLD_METER_SCALE * dt
        sprite.y = holder.phys.body:getY() + vy / C_WORLD_METER_SCALE * dt
        sprite.hurt_time = holder.hurt_time
        sprite.health = holder.health
        sprite.max_health = holder.max_health 
        
        if sprite.health and sprite.max_health and sprite.healthbar_dims then 
            sprite.rendered_health = ((sprite.rendered_health or sprite.max_health) * 0.1 + sprite.health * dt) / (0.1 + dt)
        end
    end

    local layer = sprite.anim_file.animations[sprite.cur_anim].anim_layer 

    if render.get_layer_state(layer) == true then 
        sprite.frame = sprite.frame + dt * C_TICKS_PER_SECOND
    end

end

render.update_mesh = function(mesh, holder, dt)
    if holder then 
        local vx, vy = holder.phys.body:getLinearVelocity()
        mesh.x = (holder.phys.body:getX() + (mesh.off_x or 0)) + vx / C_WORLD_METER_SCALE * dt
        mesh.y = (holder.phys.body:getY() + (mesh.off_y or 0)) + vy / C_WORLD_METER_SCALE * dt

        if holder.sprite then 
            mesh.hurt_time = holder.sprite.hurt_time
        end
    end
end

-- sprite: userdata from render.create_sprite
-- frame_off: int to offset animation time 
-- params: table. Contains:
-- x: int to change x_pos
-- y: int to change y_pos
-- rot: int, rotates the sprite
-- x_scale: int, x scale multiplier
-- y_scale: int, y scale multiplier
-- color_mult: color to multiply frame color by 
-- color_add: color to add to frame color
render.draw_mesh = function(mesh, params)
    params = params or {}
    params.x = params.x == nil and 0 or params.x
    params.y = params.y == nil and 0 or params.y
    params.rot = params.rot == nil and 0 or params.rot
    params.x_scale = params.x_scale == nil and 1 or params.x_scale
    params.y_scale = params.y_scale == nil and 1 or params.y_scale
    params.color = params.color == nil and C_COLOR_WHITE or params.color
    params.color_mult = params.color_mult == nil and C_COLOR_WHITE or params.color_mult
    params.color_add = params.color_add == nil and C_COLOR_EMPTY or params.color_add

    love.graphics.push()
    love.graphics.scale(C_RENDER_ROOT_SPRITE_SCALE)

    local color = render.apply_colors(params.color, params.color_mult, params.color_add)
    -- flash red 
    if (mesh.hurt_time or 0) > 0 then 
        local hurt_time = math.min(255,mesh.hurt_time * 255 / C_RENDER_MAX_HURT_TIME)
        local hurt_col = {r=255,g=255-hurt_time,b=255-hurt_time,a=255} 
        color = render.apply_colors(color, hurt_col)       
    end

    love.graphics.setColor(color.r / 255.0, color.g / 255.0, color.b / 255.0, color.a / 255.0)
    love.graphics.draw(mesh.mesh, mesh.x / C_RENDER_ROOT_SPRITE_SCALE + params.x, mesh.y / C_RENDER_ROOT_SPRITE_SCALE + params.y, math.rad(params.rot + mesh.rot), params.x_scale, params.y_scale, mesh.width / 2.0, mesh.height / 2.0)
    love.graphics.pop()
    love.graphics.setColor(1,1,1,1)
end

render.validate_sprite = function(sprite,log_error)
    log_error = log_error == nil and true or log_error 

    if not sprite then 
        if log_error then 
            GAME().log("Sprite is nil!!",C_LOGGER_LEVELS.ERROR)
        end
        return false 
    end

    if not sprite.anim_file then 
        if log_error then 
            GAME().log("Animation file \'"..tostring(sprite.anim_path).."\' is invalid!",C_LOGGER_LEVELS.ERROR)
        end
        
        return false 
    end

    if sprite.anim_file.animations == nil then 
        if log_error then 
            GAME().log("Animation file \'"..tostring(sprite.anim_path).."\' is invalid! No \'animations\' structure detected.",C_LOGGER_LEVELS.ERROR)
        end

        return false 
    end

    local anim = sprite.anim_file.animations[sprite.cur_anim]

    if not anim then 
        if log_error then 
            GAME().log("Animation \'"..tostring(sprite.cur_anim).."\' does not exist in \'"..tostring(sprite.anim_path).."\', aborting...", C_LOGGER_LEVELS.ERROR) 
        end
        
        return false 
    end

    return true 
end

-- sprite: userdata from render.create_sprite
-- frame_off: int to offset animation time 
-- params: table. Contains:
-- x: int to change x_pos
-- y: int to change y_pos
-- rot: int, rotates the sprite (degrees)
-- x_scale: int, x scale multiplier
-- y_scale: int, y scale multiplier
-- color_mult: color to multiply frame color by 
-- color_add: color to add to frame color
render.draw_sprite = function(sprite, frame_off, params)
    frame_off = frame_off == nil and 0 or frame_off
    params = params or {}
    params.x = params.x == nil and 0 or params.x
    params.y = params.y == nil and 0 or params.y
    params.rot = params.rot == nil and 0 or params.rot
    params.x_scale = params.x_scale == nil and 1 or params.x_scale
    params.y_scale = params.y_scale == nil and 1 or params.y_scale
    params.color_mult = params.color_mult == nil and C_COLOR_WHITE or params.color_mult
    params.color_add = params.color_add == nil and C_COLOR_EMPTY or params.color_add

    if not render.validate_sprite(sprite) then 
        return
    end
    
    local anim = sprite.anim_file.animations[sprite.cur_anim]

    -- stop render if animation is finished
    if render.sprite_animation_finished(sprite) then
        return
    end

    love.graphics.push()

    local frame, time, nframe, perc = render.get_interpolate_perc(sprite, frame_off + sprite.frame_off)
    local color = render.interpolate_color(sprite, frame_off + sprite.frame_off, params.color_mult, params.color_add)

    -- flash red 
    if (sprite.hurt_time or 0) > 0 then 
        local hurt_time = math.min(255,sprite.hurt_time * 255 / C_RENDER_MAX_HURT_TIME)
        local hurt_col = {r=255,g=255-hurt_time,b=255-hurt_time,a=255} 
        color = render.apply_colors(color, hurt_col)       
    end

    love.graphics.scale(C_RENDER_ROOT_SPRITE_SCALE)
    -- render.shader:send("mult_col",{color.r / 255 * params.color_mult.r / 255,color.g / 255 * params.color_mult.g / 255,color.b / 255 * params.color_mult.b / 255,color.a / 255 * params.color_mult.a / 255})
    -- render.shader:send("add_col",{params.color_add.r / 255,params.color_add.g / 255,params.color_add.b / 255,params.color_add.a / 255})
    love.graphics.setColor(color.r / 255.0, color.g / 255.0, color.b / 255.0, color.a / 255.0)

    love.graphics.draw(frame.image, frame.dimensions, 
        (sprite.x+render.interpolate(sprite,"x_pos")+params.x) / C_RENDER_ROOT_SPRITE_SCALE, 
        (sprite.y+render.interpolate(sprite,"y_pos")+params.y) / C_RENDER_ROOT_SPRITE_SCALE, 
        math.rad(render.interpolate(sprite,"rotate") + params.rot + sprite.rot), 
        render.interpolate(sprite,"x_scale") * params.x_scale * (sprite.flipx and -1 or 1), 
        render.interpolate(sprite,"y_scale") * params.y_scale, 
        frame.x_pivot, frame.y_pivot)

    -- render healthbar
    if sprite.health and sprite.max_health and sprite.rendered_health and sprite.healthbar_dims and sprite.health < sprite.max_health then 
        local hurt_time = math.min(255,(sprite.hurt_time or 0) * 255 / C_RENDER_MAX_HURT_TIME)
        local dims = sprite.healthbar_dims
        local perc = sprite.rendered_health / sprite.max_health 
        local health_off = sprite.healthbar_offset == nil and {x=0,y=20} or sprite.healthbar_offset
        love.graphics.setColor(C_RENDER_HEALTHBAR_BACK.r/255,C_RENDER_HEALTHBAR_BACK.g/255,C_RENDER_HEALTHBAR_BACK.b/255,C_RENDER_HEALTHBAR_BACK.a/255)
        love.graphics.rectangle("fill",
            (sprite.x+params.x+health_off.x)/C_RENDER_ROOT_SPRITE_SCALE-sprite.healthbar_dims.width/2.0,
            (sprite.y+params.y+health_off.y)/C_RENDER_ROOT_SPRITE_SCALE-sprite.healthbar_dims.height/2.0,
            sprite.healthbar_dims.width,sprite.healthbar_dims.height,1,1)
        love.graphics.setColor(math.min(255,C_RENDER_HEALTHBAR_FRONT.r/255+hurt_time),math.max(0,C_RENDER_HEALTHBAR_FRONT.g-hurt_time)/255,math.max(C_RENDER_HEALTHBAR_FRONT.b-hurt_time)/255,C_RENDER_HEALTHBAR_FRONT.a/255)
        love.graphics.rectangle("fill",
            (sprite.x+params.x+health_off.x)/C_RENDER_ROOT_SPRITE_SCALE-sprite.healthbar_dims.width/2.0,
            (sprite.y+params.y+health_off.y)/C_RENDER_ROOT_SPRITE_SCALE-sprite.healthbar_dims.height/2.0,
            sprite.healthbar_dims.width*perc,sprite.healthbar_dims.height,1,1)
end

    love.graphics.pop()
    love.graphics.setColor(1,1,1,1)
    -- love.graphics.print("r="..color.r..",g="..color.g..",b="..color.b..",a="..color.a,sprite.x,sprite.y)
end

render.get_interpolate_perc = function(sprite,frame_off)
    frame_off = frame_off == nil and 0 or frame_off 
    local cur_frame, cur, ind = render.get_frame(sprite, frame_off)
    local next_frame = render.get_frame(sprite, frame_off, 1)
    local perc = (cur+(sprite.frame%C_TICKS_PER_SECOND) / C_TICKS_PER_SECOND) / cur_frame.frames
    return cur_frame, cur, next_frame, perc
end

render.apply_colors = function(color, mult_col, add_col)
    mult_col = mult_col == nil and C_COLOR_WHITE or mult_col
    add_col = add_col == nil and C_COLOR_EMPTY or add_col
    return {
        r = math.max(0,math.min(255,color.r * ((mult_col.r or 255) / 255) + (add_col.r or 0))),
        g = math.max(0,math.min(255,color.g * ((mult_col.g or 255) / 255) + (add_col.g or 0))),
        b = math.max(0,math.min(255,color.b * ((mult_col.b or 255) / 255) + (add_col.b or 0))),
        a = math.max(0,math.min(255,color.a * ((mult_col.a or 255) / 255) + (add_col.a or 0))),
    }
end

render.interpolate_color = function(sprite, frame_off, mult_col, add_col)
    frame_off = frame_off == nil and 0 or frame_off 
    local cur_frame, cur, next_frame, perc = render.get_interpolate_perc(sprite, frame_off)

    if next_frame.interp == C_RENDER_INTERPOLATE_TYPE.NONE then 
        return render.apply_colors(cur_frame.color, mult_col, add_col)
    end

    return render.apply_colors(GAME().util.interpolate_color(cur_frame.color, next_frame.color, perc), mult_col, add_col)
end

render.interpolate = function(sprite, val)
    local frame, time, nframe, perc = render.get_interpolate_perc(sprite)

    if nframe.interp == C_RENDER_INTERPOLATE_TYPE.NONE then 
        return frame[val]
    end

    return frame[val] * (1 - perc) + nframe[val] * perc
end

render.get_frame = function(sprite,off,ind_off)
    off = off == nil and 0 or off 
    ind_off = ind_off == nil and 0 or ind_off 

    local anim = sprite.anim_file.animations[sprite.cur_anim]
    local cur_frame = ((math.floor(sprite.frame) + off))

    if anim.no_loop ~= true then 
        cur_frame = cur_frame % anim.frame_time
    else
        cur_frame = math.min(cur_frame, anim.frame_time + 1)
    end

    local ret = 1
    
    while cur_frame > anim.frames[ret].frames do 
        cur_frame = cur_frame - anim.frames[ret].frames
        
        ret = ret + 1 
    end

    ret = ret + ind_off 
    local frame_count = #anim.frames

    while ret > frame_count do 
        ret = ret - frame_count
    end

    return anim.frames[ret], cur_frame, ret
end

render.sprite_animation_finished = function(sprite)
    if not render.validate_sprite(sprite) then 
        return true
    end

    local anim = sprite.anim_file.animations[sprite.cur_anim]

    if anim.no_loop == true and sprite.frame >= anim.frame_time then
        return true 
    end

    return false 
end

render.sprite_event_triggered = function(sprite, event)
    render.validate_sprite(sprite)
    local cur_frame = math.floor(sprite.frame)
    local anim = sprite.anim_file.animations[sprite.cur_anim]
    
    if anim.no_loop ~= true then 
        cur_frame = cur_frame % anim.frame_time
    else
        cur_frame = math.min(cur_frame, anim.frame_time + 1)
    end

    local events = anim.events

    if events then 
        if events[cur_frame] == event and (sprite.event_frame[event] or 0) ~= cur_frame then 
            sprite.event_frame[event] = cur_frame 
            return true
        elseif events[cur_frame] ~= event then 
            sprite.event_frame[event] = 0 
        end
    else 
        sprite.event_frame[event] = 0 
    end

    return false 
end

render.start_animation = function(sprite, anim_name)
    sprite.cur_anim = anim_name 
    sprite.frame = 0
    render.validate_sprite(sprite)
end

return render