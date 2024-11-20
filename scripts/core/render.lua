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

    render.shader = love.graphics.newShader("resources/gfx/pixel_shader.c")
    love.graphics.setShader(render.shader)
    love.graphics.setBlendMode(C_RENDER_BLEND_MODES.ALPHA)
    render.shader:send("mult_col",{1,1,1,1})
    render.shader:send("add_col",{0,0,0,0})
end

render.get_layer_state = function(render_layer)
    return render.anim_layer_states[render_layer]
end

render.set_layer_state = function(render_layer, state)
    render.anim_layer_states[render_layer] = state
end

-- converts primitive data into complex data 
render.flush_anim_file = function(anim_obj)
    -- local anim_obj = GAME().core.registry.get_registry_object(C_REG_TYPES.ANIM_FILE, anim_id)

    if anim_obj.flushed ~= true then 
        local anims = anim_obj.animations

        for anim_name,anim in pairs(anims) do 
            local max_frame_time = 0
            anim.frames_indexed = {}
            local total_frames = #anim.frames
            for frame_ind,frame in ipairs(anim.frames) do 
                frame.index = frame_ind
                frame.image = GAME().core.registry.get_registry_object(C_REG_TYPES.IMAGE, frame.image)
                frame.image:setFilter("nearest","nearest")
                frame.dimensions = love.graphics.newQuad(
                    frame.dimensions.x, frame.dimensions.y,
                    frame.dimensions.w, frame.dimensions.h, 
                    frame.image:getPixelWidth(), frame.image:getPixelHeight())

                max_frame_time = max_frame_time + frame.frames
            end

            anim.frame_time = max_frame_time
        end

        anim_obj.flushed = true 
    end

    return anim_obj
end

render.setup_frame = function()
    love.graphics.clear()
end

render.create_sprite = function(reg_id)
    local sprite = GAME().core.registry.get_registry_object(C_REG_TYPES.SPRITE, reg_id)
    sprite.anim_file = render.flush_anim_file(GAME().core.registry.get_registry_object(C_REG_TYPES.ANIM_FILE, sprite.anim_file))
    sprite.cur_anim = sprite.default_anim
    sprite.frame = 1
    sprite.frame_offset = 0
    sprite.x = 0
    sprite.y = 0

    return sprite
end

render.update = function(dt)
end

render.update_sprite = function(sprite, holder, dt)
    local layer = sprite.anim_file.animations[sprite.cur_anim].anim_layer 
    local vx, vy = 0,0--holder.phys.body:getLinearVelocity()

    if holder then 
        sprite.x = holder.phys.body:getX() + vx / C_WORLD_METER_SCALE
        sprite.y = holder.phys.body:getY() + vy / C_WORLD_METER_SCALE    
    end

    if render.get_layer_state(layer) == true then 
        sprite.frame = sprite.frame + dt * C_TICKS_PER_SECOND
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
    
    love.graphics.push()

    local frame, time, nframe, perc = render.get_interpolate_perc(sprite, frame_off)
    local color = render.interpolate_color(sprite, frame_off, params.color_mult, params.color_add)
    -- render.shader:send("mult_col",{color.r / 255 * params.color_mult.r / 255,color.g / 255 * params.color_mult.g / 255,color.b / 255 * params.color_mult.b / 255,color.a / 255 * params.color_mult.a / 255})
    -- render.shader:send("add_col",{params.color_add.r / 255,params.color_add.g / 255,params.color_add.b / 255,params.color_add.a / 255})
    love.graphics.setColor(color.r/255, color.g/255, color.b/255, color.a/255)
    love.graphics.draw(frame.image, frame.dimensions, 
        sprite.x+render.interpolate(sprite,"x_pos")+params.x, 
        sprite.y+render.interpolate(sprite,"y_pos")+params.x, 
        math.rad(render.interpolate(sprite,"rotate") + params.rot), 
        render.interpolate(sprite,"x_scale") * params.x_scale, 
        render.interpolate(sprite,"y_scale") * params.y_scale, 
        frame.x_pivot, frame.y_pivot)

    love.graphics.setColor(1,1,1,1)
    love.graphics.print("r="..color.r..",g="..color.g..",b="..color.b..",a="..color.a,sprite.x,sprite.y)


    love.graphics.pop()
end

render.get_interpolate_perc = function(sprite,frame_off)
    frame_off = frame_off == nil and 0 or frame_off 
    local cur_frame, cur, ind = render.get_frame(sprite, frame_off)
    local next_frame = render.get_frame(sprite, frame_off, 1)
    local perc = cur / cur_frame.frames
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

    return render.apply_colors(GAME().core.util.interpolate_color(cur_frame.color, next_frame.color, perc), mult_col, add_col)
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
    local cur_frame = ((math.floor(sprite.frame) + sprite.frame_offset + off) % (anim.frame_time))
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

return render