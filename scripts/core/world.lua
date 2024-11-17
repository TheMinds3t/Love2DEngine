require("scripts.core.constants")
local world = {}

world.start_world = function()
    if world.cur_world ~= nil then 
        world.cur_world:destroy()
    end
    world.cur_world = love.physics.newWorld(C_WORLD_GRAVITY.X, C_WORLD_GRAVITY.Y, true)
    world.cur_world:setCallbacks(world.contact_start, world.contact_end, world.pre_solve_contact, world.post_solve_contact)
    world.cur_world:setContactFilter(world.contact_filter)
end

world.contact_filter = function(a, b)
    local a_dt, b_dt = a:getUserData(), b:getUserData()
    if a_dt and b_dt then 
        if a_dt.contact_type == C_WORLD_CONTACT_TYPES.NONE or b_dt.contact_type == C_WORLD_CONTACT_TYPES.NONE then 
            return false 
        elseif a_dt.contact_type == C_WORLD_CONTACT_TYPES.DYNAMIC and a_dt.should_collide and a_dt:should_collide(b_dt, a, b) then 
            return true 
        elseif b_dt.contact_type == C_WORLD_CONTACT_TYPES.DYNAMIC and b_dt.should_collide and b_dt:should_collide(b_dt, a, b) then 
            return true 
        else 
            return a_dt.contact_type == C_WORLD_CONTACT_TYPES.ALL
        end
    end

    return true 
end

world.contact_start = function(a, b, coll)
    x,y = coll:getNormal()
    local a_dt, b_dt = a:getUserData(), b:getUserData()

    if a_dt and a_dt.on_collide then 
        a_dt.on_collide(a_dt, b_dt, a:getBody(), b:getBody(), x, y, coll)
    end

    if b_dt and b_dt.on_collide then 
        b_dt.on_collide(b_dt, a_dt, b:getBody(), a:getBody(), x, y, coll)
    end
end

world.contact_end = function(a, b, coll)

end

world.pre_solve_contact = function(a, b, coll)
end

world.post_solve_contact = function(a, b, coll, norm_impulse, tang_impulse)

end

world.is_active = function()
    return world.cur_world ~= nil
end

world.get_world = function()
    return world.cur_world 
end

world.base_object_update = function(data, dt, body)
    data.ticks = (data.ticks or 0) + 1
    data.time = (data.time or 0) + dt
    if data.update then 
        data:update(dt * C_WORLD_UPDATE_SCALAR, body)    
    end

    return not data.destroy
end

world.update = function(dt)
    if world.is_active() then 
        local bodies = world.cur_world:getBodies()
        for _,body in ipairs(bodies) do 
            local data = body:getUserData() 

            if data then 
                if not world.base_object_update(data, dt * C_WORLD_UPDATE_SCALAR, body) then 
                    data.phys.fixture:destroy()
                    data.phys.body:destroy()
                    GAME().log("Removed object \'"..data.id.."\' from world. #bodies = "..tostring(#bodies), C_LOGGER_LEVELS.DEBUG)
                end
            end
        end

        world.cur_world:update(dt * C_WORLD_UPDATE_SCALAR, C_WORLD_VEL_ITERATIONS, C_WORLD_POS_ITERATIONS)
    end
end

world.render = function()
    if world.is_active() then 
        for _,body in ipairs(world.cur_world:getBodies()) do 
            local dt = body:getUserData() 

            if dt and dt.render then 
                dt:render(body)
            end
        end
    end
end


return world 