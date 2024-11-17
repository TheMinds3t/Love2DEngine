require("scripts.core.constants")

return {
    clone_on_create = true,
    entries = {
        TEST = GAME().core.filehelper.load_file("scripts/definitions/registries/objects/player.lua"),
        BLOCK = {
            init = function(self,x,y)
                self.phys = GAME().core.physics.new_rectangle(self,x,y,200,50,C_PHYSICS_BODY_TYPES.STATIC)
            end,
            render = function(self, body) 
                love.graphics.push()
                local x,y = body:getPosition()
                love.graphics.setColor(255,0,0,255)
                love.graphics.translate(x,y)
                love.graphics.rotate(body:getAngle())
                love.graphics.rectangle("fill", -100, -25, 200, 50)
                love.graphics.pop()
            end,
        },
        ROTATING_BLOCK = {
            init = function(self,x,y)
                self.phys = GAME().core.physics.new_rectangle(self,x,y,200,50,C_PHYSICS_BODY_TYPES.STATIC)
                self.phys.body:setGravityScale(0)
            end,
            update = function(self, dt, body)
                body:setAngle(math.cos(self.ticks or 0))
            end,
            render = function(self, body) 
                love.graphics.push()
                local x,y = body:getPosition()
                love.graphics.setColor(255,0,0,255)
                love.graphics.translate(x,y)
                love.graphics.rotate(body:getAngle())
                love.graphics.rectangle("fill", -100, -25, 200, 50)
                love.graphics.pop()
            end,
        }
    }
}