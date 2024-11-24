require("scripts.core.constants")
local world = {}

world.players = {}

world.add_player = function(player_obj)
    if world.cur_world ~= nil and player_obj.world_seed ~= world.world_seed then 
        table.insert(world.players, player_obj)
        player_obj.world_seed = world.world_seed
    end
end

world.start_world = function()
    if world.cur_world ~= nil then 
        world.cur_world:destroy()
    end
    world.players = {}
    world.cur_world = love.physics.newWorld(C_WORLD_GRAVITY.X * C_WORLD_METER_SCALE, C_WORLD_GRAVITY.Y * C_WORLD_METER_SCALE, true)
    world.cur_world:setCallbacks(world.contact_start, world.contact_end, world.pre_solve_contact, world.post_solve_contact)
    world.cur_world:setContactFilter(world.contact_filter)
    world.world_seed = love.timer.getTime()
    world.cur_ent_index = 1
end

world.get_ent_index = function()
    world.cur_ent_index = world.cur_ent_index + 1
    return world.cur_ent_index - 1
end

world.contact_filter = function(a, b)
    local a_dt, b_dt = a:getUserData(), b:getUserData()
    if a_dt and b_dt then 
        if a_dt.contact_type == C_WORLD_CONTACT_TYPES.NONE or b_dt.contact_type == C_WORLD_CONTACT_TYPES.NONE then 
            return false 
        else
            local a_col = a_dt.contact_type == C_WORLD_CONTACT_TYPES.ALL or a_dt.should_collide and a_dt:should_collide(b_dt, a, b)
            local b_col = b_dt.contact_type == C_WORLD_CONTACT_TYPES.ALL or b_dt.should_collide and b_dt:should_collide(a_dt, b, a)
            
            if a_dt.contact_type == C_WORLD_CONTACT_TYPES.DYNAMIC and a_col then 
                return true 
            elseif b_dt.contact_type == C_WORLD_CONTACT_TYPES.DYNAMIC and b_col then 
                return true 
            else 
                return a_col and b_col
            end                
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
    data.time = (data.time or 0) + dt
    data.ticks = math.floor(data.time * C_TICKS_PER_SECOND)

    if data.update then 
        data:update(dt * C_WORLD_UPDATE_SCALAR, body)    
    end

    if body:getType() ~= C_PHYSICS_BODY_TYPES.STATIC then 
        body:applyForce(C_WORLD_GRAVITY.X * C_ADDITIONAL_GRAV_SCALAR,C_WORLD_GRAVITY.Y * C_ADDITIONAL_GRAV_SCALAR)
        body:setInertia(0)
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
                elseif data.next_tick ~= nil then 
                    data.next_tick()
                    data.next_tick = nil
                end
            end
        end

        world.cur_world:update(dt * C_WORLD_UPDATE_SCALAR, C_WORLD_VEL_ITERATIONS, C_WORLD_POS_ITERATIONS)
    end
end

world.render = function()
    if world.is_active() then 
        love.graphics.push()
        love.graphics.scale(0.5,0.5)
        love.graphics.pop()
        for _,body in ipairs(world.cur_world:getBodies()) do 
            local dt = body:getUserData() 

            if dt and dt.render then 
                dt:render(body)
            end
        end
    end
end

return world 