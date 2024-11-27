require("scripts.core.constants")
local physics = {}

physics.init = function()
    love.physics.setMeter(C_WORLD_METER_SCALE)
end

physics.new_rectangle = function(holder,x,y,w,h,style)
    if GAME().world.is_active() then 
        style = style == nil and C_PHYSICS_BODY_TYPES.STATIC or style
        local world = GAME().world.get_world()
        local ret = {
            body = love.physics.newBody(world, x, y, style),
            shape = love.physics.newRectangleShape(w, h)
        }    

        ret.fixture = love.physics.newFixture(ret.body, ret.shape) -- this holds most properties
        ret.body:setUserData(holder)
        ret.fixture:setUserData(holder)
        ret.fixture:setRestitution(0)
        ret.fixture:setDensity(0)
        ret.body:setAngularDamping(0)
        ret.body:setLinearDamping(0)

        return ret
    end
end

-- physics.new_circle = function(holder,x,y,r,style)
--     if GAME().world.is_active() then 
--         style = style == nil and C_PHYSICS_BODY_TYPES.STATIC or style
--         local world = GAME().world.get_world()
--         local ret = {
--             body = love.physics.newBody(world, x, y, style),
--             shape = love.physics.newCircleShape(r)
--         }    

--         ret.fixture = love.physics.newFixture(ret.body, ret.shape)
--         ret.body:setUserData(holder)
--         return ret
--     end
-- end

-- this is all that is needed to create a new entity in the world
physics.create_holder_from = function(entry,x,y,params)
    local new_obj = GAME().registry.get_registry_object(C_REG_TYPES.OBJECT, entry)

    if new_obj == nil then 
        return 
    end

    new_obj.id = entry 
    new_obj.contact_type = new_obj.contact_type == nil and C_WORLD_CONTACT_TYPES.ALL or new_obj.contact_type
    new_obj.index = GAME().world.get_ent_index()
    new_obj.x = x
    new_obj.y = y
    new_obj.last_tick_state = {}
    
    if new_obj.phys then 
        new_obj.phys.fixture:setCategory(new_obj.contact_type)

        if new_obj.contact_type == C_WORLD_CONTACT_TYPES.NONE then 
            new_obj.phys.fixture:setMask(C_WORLD_CONTACT_TYPES)
        end    
    end

    new_obj.util = physics.util

    new_obj:init(x,y,params == nil and {} or params)

    if new_obj.id == "PLAYER" then 
        GAME().world.add_player(new_obj)
    end

    return new_obj
end

physics.util = {
    is_tick = function(self, tick, off)
        off = off == nil and 0 or off 

        if (self.ticks + off) % tick == 0 and (self.last_tick_state[tick] or 0) ~= self.ticks then
            self.last_tick_state[tick] = self.ticks  
            return true
        elseif (self.ticks + off) % tick ~= 0 then 
            self.last_tick_state[tick] = 0
        end

        return false 
    end,

    wrap_screen = function(self, body)
        local viewport = GAME().camera.get_camera_viewport()

        if viewport then 
            local width = (self.width or 0) / 2
            local height = (self.height or 0) / 2
            if body:getY() > viewport.y + viewport.height + height then 
                body:setY(viewport.y - height)
            end
    
            if body:getY() < viewport.y - height then 
                body:setY(viewport.y + viewport.height + width)
            end
    
            if body:getX() < viewport.x - width then 
                body:setX(viewport.x + viewport.width + width)
            end
    
            if body:getX() > viewport.x + viewport.width + width then 
                body:setX(viewport.x - width)
            end    
        end
    end
}

physics.add_life_data = function(obj, max_health)
    obj.health = max_health 
    obj.max_health = max_health
    obj.target = nil 
end

physics.set_target = function(obj)
    obj.target = nil 

    for _,player in ipairs(GAME().world.players) do 
        local targ_dist = obj.target == nil and -1 or GAME().util.get_distance(obj.target.phys.body:getX(),obj.target.phys.body:getY(),obj.phys.body:getX(),obj.phys.body:getY())
        local player_dist = GAME().util.get_distance(player.phys.body:getX(),player.phys.body:getY(),obj.phys.body:getX(),obj.phys.body:getY())
        if obj.target == nil or targ_dist > player_dist then 
            obj.target = player
        end
    end
end

return physics