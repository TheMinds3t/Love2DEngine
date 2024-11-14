local render = {}

render.anim_files = {}
render.images = {}

render.transform_layers = {}

render.register_file = function(file)
    assert(render.anim_files[file] ~= nil, "\'"..file.."\' is already registered!")

    if render.anim_files[file] == nil then 
        render.anim_files = GAME().core.filehelper.load_file(file, true)
    end
end

render.get_anim_file = function(file)
    assert(render.anim_files[file] == nil, "\'"..file.."\' is not registered!")
    return render.anim_files[file]
end

render.create_anim_data = function(file, anim_name)
    return {
        frame = 0,
        max_frame = #render.get_anim_file(file).animations[anim_name].frames,
    }
end

-- file: string
-- anim_data: userdata
-- anim_offset: number
-- transform: love.math.Transform
render.draw_sprite = function(file, anim_data, anim_offset, transform)
    
end

render.draw_sprite_layer = function(file, anim_data, layer_id, anim_offset, transform)

    love.graphics.draw()
end

return render