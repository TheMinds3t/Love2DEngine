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
                frame.image = GAME().core.registry.get_registry_object(C_REG_TYPES.IMAGE, frame.image)
                frame.image:setFilter("nearest","nearest")
                frame.dimensions = love.graphics.newQuad(
                    frame.dimensions.x, frame.dimensions.y,
                    frame.dimensions.w, frame.dimensions.h, 
                    frame.image:getPixelWidth(), frame.image:getPixelHeight())

                local frames = frame.frames
                local next_frame_ind = frame_ind == total_frames and 1 or ((frame_ind + 1)%(total_frames + 1))
                local next_frame = anim.frames[next_frame_ind]
                -- GAME().log("anim="..anim_name..", ind=="..frame_ind..",next_ind=="..next_frame_ind..", frame="..GAME().core.filehelper.serialize(next_frame))

                while frames > 0 do 
                    max_frame_time = max_frame_time + 1
                    local perc = frames / frame.frames
                    -- local new_transform = GAME().core.util.interpolate_transform(frame.transform, next_frame.transform, perc)
                    anim.frames_indexed[max_frame_time] = GAME().core.util.deep_copy(frame)
                    -- anim.frames_indexed[max_frame_time].transform = new_transform
                    anim.frames_indexed[max_frame_time].color = frame.color--GAME().core.util.interpolate_color(frame.color, next_frame.color, perc)
                    -- GAME().log("anim="..anim_name..", frame_ind="..max_frame_time..", frame="..GAME().core.filehelper.serialize(anim.frames_indexed[max_frame_time]))
                    frames = frames - 1
                end
            end

            anim.frame_time = max_frame_time
        end

        anim_obj.flushed = true 
    end
end

render.create_sprite = function(reg_id)
    local sprite = GAME().core.registry.get_registry_object(C_REG_TYPES.SPRITE, reg_id)
    sprite.anim_file = GAME().core.registry.get_registry_object(C_REG_TYPES.ANIM_FILE, sprite.anim_file).file
    render.flush_anim_file(sprite.anim_file)
    sprite.cur_anim = sprite.default_anim
    sprite.frame = 1
    sprite.x = 0
    sprite.y = 0

    return sprite
end

render.update = function(dt)

end

render.update_sprite = function(sprite, holder, dt)
    local layer = sprite.anim_file.animations[sprite.cur_anim].anim_layer 
    local vx, vy = 0,0--holder.phys.body:getLinearVelocity()
    sprite.x = holder.phys.body:getX() + vx / C_WORLD_METER_SCALE
    sprite.y = holder.phys.body:getY() + vy / C_WORLD_METER_SCALE

    if render.get_layer_state(layer) == true then 
        sprite.frame = sprite.frame + dt * C_TICKS_PER_SECOND
    end
end

-- sprite: userdata from render.create_sprite
-- frame_offset: number (0)
-- transform: love.math.Transform (C_RENDER_EMPTY_TRANSFORM)
render.draw_sprite = function(sprite, frame_offset)
    frame_offset = frame_offset == nil and 0 or math.floor(frame_offset)
    love.graphics.push()
    local frame = render.get_frame(sprite, frame_offset)
    love.graphics.translate(sprite.x-frame.x_pivot*C_RENDER_ROOT_SPRITE_SCALE, sprite.y-frame.y_pivot*C_RENDER_ROOT_SPRITE_SCALE)
    love.graphics.setColor(frame.color.r, frame.color.g, frame.color.b, frame.color.a)
    love.graphics.draw(frame.image, frame.dimensions, render.active_transform)

    love.graphics.pop()
end

render.get_frame = function(sprite, frame_offset)
    frame_offset = frame_offset == nil and 0 or math.floor(frame_offset)
    local anim = sprite.anim_file.animations[sprite.cur_anim]
    local cur_frame = ((math.floor(sprite.frame) + frame_offset) % (anim.frame_time)) + 1
    return anim.frames_indexed[cur_frame]
end

return render