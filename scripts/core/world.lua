require("scripts.core.constants")
local world = {}

world.start_world = function()
    world.cur_world = love.physics.newWorld(C_WORLD_GRAVITY.X, C_WORLD_GRAVITY.Y, true)
    world.cur_world:setCallbacks(world.contact_start, world.contact_end, world.pre_solve_contact, world.post_solve_contact)
end

world.contact_start = function(a, b, coll)
    x,y = coll:getNormal()
    local a_dt, b_dt = a:getUserData(), b:getUserData()

    if a_dt and a_dt.on_collide then 
        a_dt.on_collide(a_dt, b_dt, a:getBody(), b:getBody(), x, y)
    end

    if b_dt and b_dt.on_collide then 
        b_dt.on_collide(b_dt, a_dt, b:getBody(), a:getBody(), x, y)
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

world.base_object_update = function(dt, body)
    dt.ticks = (dt.ticks or 0) + 1
end

world.update = function(dt)
    if world.is_active() then 
        for _,body in ipairs(world.cur_world:getBodies()) do 
            local dt = body:getUserData() 

            if dt and dt.update then 
                world.base_object_update(dt, body)
                dt:update(body)
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