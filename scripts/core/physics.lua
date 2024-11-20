require("scripts.core.constants")
local physics = {}

physics.init = function()
    love.physics.setMeter(C_WORLD_METER_SCALE)
end

physics.new_rectangle = function(holder,x,y,w,h,style)
    if GAME().core.world.is_active() then 
        style = style == nil and C_PHYSICS_BODY_TYPES.STATIC or style
        local world = GAME().core.world.get_world()
        local ret = {
            body = love.physics.newBody(world, x, y, style),
            shape = love.physics.newRectangleShape(w, h)
        }    

        ret.fixture = love.physics.newFixture(ret.body, ret.shape) -- this holds most properties
        ret.body:setUserData(holder)
        ret.fixture:setUserData(holder)
        return ret
    end
end

-- physics.new_circle = function(holder,x,y,r,style)
--     if GAME().core.world.is_active() then 
--         style = style == nil and C_PHYSICS_BODY_TYPES.STATIC or style
--         local world = GAME().core.world.get_world()
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
    local new_obj = GAME().core.registry.get_registry_object(C_REG_TYPES.OBJECT, entry)
    new_obj.id = entry 
    new_obj.contact_type = new_obj.contact_type == nil and C_WORLD_CONTACT_TYPES.ALL or new_obj.contact_type

    if new_obj.phys then 
        new_obj.phys.fixture:setCategory(new_obj.contact_type)

        if new_obj.contact_type == C_WORLD_CONTACT_TYPES.NONE then 
            new_obj.phys.fixture:setMask(C_WORLD_CONTACT_TYPES)
        end    
    end

    new_obj.util = physics.util

    new_obj:init(x,y,params or {})

    return new_obj
end

physics.util = {
    is_tick = function(self, tick, off)
        off = off == nil and 0 or off 

        if (self.ticks + off) % tick == 0 and (self.last_tick_state or 0) ~= true then
            self.last_tick_state = true  
            return true
        else 
            self.last_tick_state = false
        end

        return false 
    end
}

return physics