local ui = {}
ui.dialogue = {}
ui.cur_dialogue = nil
ui.goal_dialogue = nil

ui.init = function()
    ui.buffer_sprite = GAME().render.create_sprite("UI_BUFFER_WHEEL")
    ui.buffer_sprite.opacity = 0
    ui.dialogue_opacity = 0
    local w,h = love.graphics.getDimensions()

    ui.recalc_window_scale(w,h)
end

ui.update = function(dt) 
    GAME().render.update_sprite(ui.buffer_sprite, nil, dt)
    ui.buffer_sprite.x = C_WINDOW_DIMENSIONS.WIDTH - 80
    ui.buffer_sprite.y = C_WINDOW_DIMENSIONS.HEIGHT - 80

    if GAME().threads.is_blocked() then 
        ui.buffer_sprite.opacity = math.min(1,ui.buffer_sprite.opacity + dt)
    else 
        ui.buffer_sprite.opacity = math.max(0,ui.buffer_sprite.opacity - dt * 2)

        if #ui.dialogue > 0 then 
            if ui.cur_dialogue == nil then 
                ui.cur_dialogue = ""
                ui.goal_dialogue = ui.dialogue[1] 
            end

            if ui.cur_dialogue:len() < ui.goal_dialogue:len() then 
                ui.dialogue_opacity = math.min(1,ui.dialogue_opacity + dt)
            end

            ui.dialogue_tick = (ui.dialogue_tick or 0) + dt * C_TICKS_PER_SECOND

            if ui.dialogue_tick >= C_UI_DIALOGUE_UPDATE_FREQUENCY then 
                if ui.cur_dialogue:len() < ui.goal_dialogue:len() then 
                    ui.dialogue_tick = 0
                    ui.cur_dialogue = ui.cur_dialogue..ui.goal_dialogue:sub(ui.cur_dialogue:len()+1,ui.cur_dialogue:len()+1)
                else
                    local hold_clamped = math.min(C_UI_DIALOGUE_MAX_HOLD,math.max(C_UI_DIALOGUE_MIN_HOLD,ui.cur_dialogue:len() * C_UI_DIALOGUE_HOLD_SCALAR))
                    if ui.dialogue_tick / C_TICKS_PER_SECOND >= hold_clamped then 
                        if #ui.dialogue > 1 then 
                            ui.cur_dialogue = nil
                            ui.goal_dialogue = nil
                            table.remove(ui.dialogue,1)    
                        else
                            ui.dialogue_opacity = math.max(0,ui.dialogue_opacity - dt * 2)

                            if ui.dialogue_opacity == 0.0 then 
                                ui.cur_dialogue = nil
                                ui.goal_dialogue = nil
                                table.remove(ui.dialogue,1)    
                            end    
                        end
                    end
                end
            end
        end
    end
end

ui.draw = function()
    local sx, sy, ox, oy = ui.get_window_scale()
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    love.graphics.push()
    love.graphics.scale(C_RENDER_ROOT_UI_SCALE*sx,C_RENDER_ROOT_UI_SCALE*sy)

    if ui.buffer_sprite.opacity > 0 then 
        GAME().render.draw_sprite(ui.buffer_sprite,0,{rot=GAME().time * 45, color_mult={r=255,g=255,b=255,a=ui.buffer_sprite.opacity * 255}})
    end

    if ui.cur_dialogue ~= nil then 
        local wrapped_width, wrapped = GAME().render.font:getWrap(ui.cur_dialogue, C_UI_DIALOGUE_TEXT_WIDTH*C_RENDER_ROOT_UI_SCALE)
        local x = w / 4.0/sx
        local y = h / 2.0/sy - C_UI_DIALOGUE_DIMS.HEIGHT / 2.0 / sy - 10*sy
        local rx, ry = ui.draw_box(x, y, C_UI_DIALOGUE_DIMS.WIDTH, C_UI_DIALOGUE_DIMS.HEIGHT, {r=255,g=255,b=255,a=ui.dialogue_opacity * 255})
        love.graphics.pop()
        love.graphics.scale(sx,sy)
        love.graphics.translate(-C_UI_DIALOGUE_TEXT_WIDTH*C_RENDER_ROOT_UI_SCALE/2.0, -C_UI_DIALOGUE_DIMS.HEIGHT + GAME().render.font_height+ry*2)
        local cur_off = 0
        for ind,txt in ipairs(wrapped) do 
            love.graphics.print(txt, x*2, y*2 + cur_off * GAME().render.font_height * 4.0/3.0 - GAME().render.font_height)
            cur_off = cur_off + 1 + (txt:match("\n",1,true) or 0)
        end
    else 
        love.graphics.pop()
    end
end

ui.get_window_scale = function()
    return ui.scaled_x, ui.scaled_y, ui.off_x, ui.off_y
end

ui.recalc_window_scale = function(w,h)
    w = w == nil and love.graphics.getWidth() or w 
    h = h == nil and love.graphics.getHeight() or h 
    local og_w,og_h = w, h
    w = math.min(w / GAME().render.canvas:getWidth(), h / GAME().render.canvas:getHeight())
    h = w
    local w_size = GAME().render.canvas:getWidth() * w
    local h_size = GAME().render.canvas:getHeight() * h

    ui.scaled_x = w 
    ui.scaled_y = h
    ui.off_x = math.floor(og_w - w_size)
    ui.off_y = math.floor(og_h - h_size)
    return ui.get_window_scale()
end

function love.resize(w, h)
    ui.recalc_window_scale(w,h)
end

ui.add_dialogue = function(msg)
    local wrapped_width, wrapped = GAME().render.font:getWrap(msg, C_UI_DIALOGUE_TEXT_WIDTH*C_RENDER_ROOT_UI_SCALE)
    while #wrapped > 3 do 
        ui.add_dialogue(wrapped[1]..wrapped[2]..wrapped[3])
        table.remove(wrapped, 1)
        table.remove(wrapped, 1)
        table.remove(wrapped, 1)
    end

    table.insert(ui.dialogue, wrapped[1]..(wrapped[2] or "")..(wrapped[3] or ""))
end

ui.draw_box = function(x,y,width,height,color_mult)
    color_mult = color_mult == nil and C_COLOR_WHITE or color_mult
    local rx = math.min(C_UI_MAX_BOX_EDGE_SIZE,math.max(C_UI_MAX_BOX_EDGE_SIZE,math.floor(width/C_UI_BOX_ROUND_FACTOR)))
    local ry = math.min(C_UI_MAX_BOX_EDGE_SIZE,math.max(C_UI_MAX_BOX_EDGE_SIZE,math.floor(height/C_UI_BOX_ROUND_FACTOR)))

    love.graphics.push()
    love.graphics.translate(-width/2.0,-height/2.0)
    love.graphics.setColor(
        C_UI_BOX_BACKGROUND_COLOR.r/255.0*(color_mult.r or 1)/255.0,
        C_UI_BOX_BACKGROUND_COLOR.g/255.0*(color_mult.g or 1)/255.0,
        C_UI_BOX_BACKGROUND_COLOR.b/255.0*(color_mult.b or 1)/255.0,
        C_UI_BOX_BACKGROUND_COLOR.a/255.0*(color_mult.a or 1)/255.0)
    love.graphics.rectangle("fill",x,y,width,height,rx,ry,C_UI_BOX_EDGES)
    love.graphics.setColor(
        C_UI_BOX_OUTLINE_COLOR.r/255.0*(color_mult.r or 1)/255.0,
        C_UI_BOX_OUTLINE_COLOR.g/255.0*(color_mult.g or 1)/255.0,
        C_UI_BOX_OUTLINE_COLOR.b/255.0*(color_mult.b or 1)/255.0,
        C_UI_BOX_OUTLINE_COLOR.a/255.0*(color_mult.a or 1)/255.0)
    love.graphics.rectangle("line",x,y,width,height,rx,ry,C_UI_BOX_EDGES)
    love.graphics.pop()

    return rx, ry
end

return ui 