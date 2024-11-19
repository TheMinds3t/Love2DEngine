local input = {}
input.active_keys = {}

input.init = function()
    input.create_input_set() --initialize defaults
end

input.create_input_set = function(input_data)
    input.cur_scheme = {refs = {}, key_map = {}, mouse_map = {}, config_keys = {}}
    
    local keys = (input_data ~= nil and input_data or GAME().core.registry.get_keys_for(C_REG_TYPES.INPUT))

    for _,key in ipairs(keys) do 
        local obj = GAME().core.registry.get_registry_object(C_REG_TYPES.INPUT,key)
        input.cur_scheme.refs[key] = obj

        if obj.scancode then 
            input.cur_scheme.key_map[obj.config_key or obj.scancode] = key 
        end

        if obj.mouse_button then 
            input.cur_scheme.mouse_map[obj.mouse_button] = key
        end
    end
end

input.export_input_scheme = function(file)
    GAME().core.filehelper.write_file(C_INPUT_SCHEME_FOLDER..file,function() 
        return {GAME().core.filehelper.serialize(input.cur_scheme)}
    end)
end

input.import_input_scheme = function(file)
    input.create_input_set(GAME().core.filehelper.deserialize(GAME().core.filehelper.read_file(C_INPUT_SCHEME_FOLDER..file)[1]))
end

function love.keypressed(key, scancode, isrepeat)
    if input.cur_scheme ~= nil then 
        local control = input.cur_scheme.key_map[scancode]

        if key == "v" then 
            GAME().vsync_test = not GAME().vsync_test
            love.window.setVSync((love.window.getVSync() + 1) % 2)
        end 

        if control then 
            input.active_keys = input.active_keys or {}
            input.active_keys[control] = 2
            GAME().log("Input \'"..control.."\' is pressed! key=\'"..key.."\', isrepeat="..tostring(isrepeat)) 
        end
    end
end

function love.keyreleased(key, scancode)
    if input.cur_scheme ~= nil then 
        local control = input.cur_scheme.key_map[scancode]
        if control then 
            input.active_keys = input.active_keys or {}
            input.active_keys[control] = nil
            GAME().log("Input \'"..control.."\' is released! key=\'"..key.."\'") 
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    input.mouse_x = x
    input.mouse_y = y
    input.cur_scheme.mouse_map = input.cur_scheme.mouse_map or {}

    if input.cur_scheme ~= nil then 
        local control = input.cur_scheme.mouse_map[button]
        if control then 
            input.active_mouse = input.active_mouse or {}
            input.active_mouse[control] = 2
            GAME().log("Input \'"..control.."\' is pressed! mousebut=\'"..button.."\'") 
        end
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    input.mouse_x = x
    input.mouse_y = y
    input.cur_scheme.mouse_map = input.cur_scheme.mouse_map or {}

    if input.cur_scheme ~= nil then 
        local control = input.cur_scheme.mouse_map[button]
        if control then 
            input.active_mouse = input.active_mouse or {}
            input.active_mouse[control] = nil
            GAME().log("Input \'"..control.."\' is released! mousebutton=\'"..button.."\'") 
        end
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    input.mouse_x = x
    input.mouse_y = y
end

input.is_input_active = function(control, consume)
    consume = consume == nil and false or consume
    input.active_keys = input.active_keys or {}
    input.active_mouse = input.active_mouse or {}

    if consume and input.active_keys[control] == 2 then 
        input.active_keys[control] = 1
        return true 
    elseif consume and input.active_mouse[control] == 2 then 
        input.active_mouse[control] = 1
        return true 
    end

    local input_state = math.max(input.active_keys[control] or 0, input.active_mouse[control] or 0)

    if consume then 
        return input_state == 2
    else
        return input_state > 0
    end
end

return input