local ui = {}

ui.init = function()
    ui.buffer_sprite = GAME().core.render.create_sprite("UI_BUFFER_WHEEL")
    ui.buffer_sprite.opacity = 0
end

ui.update = function(dt) 
    GAME().core.render.update_sprite(ui.buffer_sprite, nil, dt)
    ui.buffer_sprite.x = 100
    ui.buffer_sprite.y = 100

    if GAME().core.threads.is_blocked() then 
        ui.buffer_sprite.opacity = math.min(1,ui.buffer_sprite.opacity + dt)
    else 
        ui.buffer_sprite.opacity = math.max(0,ui.buffer_sprite.opacity - dt * 2)
    end
end

ui.draw = function()
    if ui.buffer_sprite.opacity > 0 then 
        GAME().core.render.draw_sprite(ui.buffer_sprite,0,{rot=GAME().time * 45, color_mult={r=255,g=255,b=255,a=ui.buffer_sprite.opacity * 255}})
    end
end

return ui 