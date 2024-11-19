require("scripts.core.constants")

return {
    clone_on_create = true,
    entries = {
        TEST = GAME().core.filehelper.load_file("scripts/definitions/registries/objects/player.lua"),
        BLOCK = {
            init = function(self,x,y,params)
                self.width = params.width or 200
                self.height = params.height or 50
                self.phys = GAME().core.physics.new_rectangle(self,x,y,self.width,self.height,C_PHYSICS_BODY_TYPES.STATIC)
            end,
            render = function(self, body) 
                love.graphics.push()
                local x,y = body:getPosition()
                love.graphics.setColor(255,0,0,255)
                love.graphics.translate(x,y)
                love.graphics.rotate(body:getAngle())
                love.graphics.rectangle("fill", -self.width / 2, -self.height / 2, self.width, self.height)
                love.graphics.pop()
            end,
        },
        ROTATING_BLOCK = {
            init = function(self,x,y,params)
                self.width = params.width or 200
                self.height = params.height or 50
                self.phys = GAME().core.physics.new_rectangle(self,x,y,self.width,self.height,C_PHYSICS_BODY_TYPES.STATIC)
            end,
            update = function(self, dt, body)
                body:setAngle(math.cos(self.time or 0)/ 16.0)
            end,
            render = function(self, body) 
                love.graphics.push()
                local x,y = body:getPosition()
                love.graphics.setColor(255,0,0,255)
                love.graphics.translate(x,y)
                love.graphics.rotate(body:getAngle())
                love.graphics.rectangle("fill", -self.width / 2, -self.height / 2, self.width, self.height)
                love.graphics.pop()
            end,
        },
        RAINDROP = {
            contact_type = C_WORLD_CONTACT_TYPES.NONE,

            init = function(self,x,y)
                self.phys = GAME().core.physics.new_rectangle(self,x,y,25,25,C_PHYSICS_BODY_TYPES.DYNAMIC)
            end,
            update = function(self, dt, body)
                -- body:applyForce(0,10)

                if body:getY() > 625 then 
                    self.destroy = true 
                end
            end,
            render = function(self, body) 
                love.graphics.push()
                local x,y = body:getPosition()
                love.graphics.setColor(200,200,255,200)
                love.graphics.translate(x,y)
                love.graphics.rotate(body:getAngle())
                love.graphics.ellipse("fill", -7.5, -12.5, 15, 25)
                love.graphics.pop()
            end,
            on_collide = function(self, b_data, a, b, x, y, coll)
                if b_data and b_data.id ~= "RAINMAKER" and b_data.id ~= "RAINDROP" then 
                    self.destroy = true
                else
                    coll:setEnabled(false)
                end
            end,
            should_collide = function(self, b_dt, a, b)
                return b_dt.id ~= "RAINDROP" and b_dt.id ~= "RAINMAKER"
            end
        },
        RAINMAKER = {
            contact_type = C_WORLD_CONTACT_TYPES.NONE,
            init = function(self,x,y)
                self.phys = GAME().core.physics.new_rectangle(self,x,y,25,25,C_PHYSICS_BODY_TYPES.STATIC)
            end,
            update = function(self, dt, body) 
                if self.ticks % 10 == 0 then 
                    GAME().core.physics.create_holder_from("RAINDROP",body:getX(),body:getY())
                end

                body:setX(400 + math.cos(self.time * 1.67) * 300)
            end,
            render = function(self, body) end,
        }
    }
}