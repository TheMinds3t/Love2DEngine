require("scripts.core.constants")
local player = {
    init = function(self,x,y)
        self.phys = GAME().core.physics.new_rectangle(self,x,y,50,50,C_PHYSICS_BODY_TYPES.DYNAMIC)
        self.phys.fixture:setRestitution(0)
        self.phys.body:setMass(1)
        self.phys.body:setFixedRotation(true)
    end,
    max_jump_time = C_PLAYER_MAX_JUMP_TIME,
    update = function(self, dt, body)
        x, y = body:getLinearVelocity( )
        local targx = 0
        local sprint_flag = GAME().core.input.is_input_active(C_INPUT_IDS.SPRINT)

        if GAME().core.input.is_input_active(C_INPUT_IDS.LEFT) then 
            if GAME().core.input.is_input_active(C_INPUT_IDS.LEFT,true) then 
                body:applyLinearImpulse(-C_PLAYER_HORI_MOVE_SPEED*C_PLAYER_HORI_MOVE_START_SCALAR*(sprint_flag and 1.0 or C_PLAYER_WALK_SCALAR),0)
            end

            targx = targx - C_PLAYER_HORI_MOVE_SPEED
        end

        if GAME().core.input.is_input_active(C_INPUT_IDS.RIGHT) then 
            if GAME().core.input.is_input_active(C_INPUT_IDS.RIGHT,true) then 
                body:applyLinearImpulse(C_PLAYER_HORI_MOVE_SPEED*C_PLAYER_HORI_MOVE_START_SCALAR*(sprint_flag and 1.0 or C_PLAYER_WALK_SCALAR),0)
            end

            targx = targx + C_PLAYER_HORI_MOVE_SPEED
        end

        if GAME().core.input.is_input_active(C_INPUT_IDS.JUMP) then
            if (self.airborne or false) == false then 
                body:applyLinearImpulse(0,-C_PLAYER_JUMP_STRENGTH)                        
                self.active_jump = true 
            end

            self.jump_time = math.min((self.jump_time or 0) + dt, self.max_jump_time)

            if self.jump_time < self.max_jump_time and self.active_jump == true then 
                body:applyLinearImpulse(0,-C_PLAYER_JUMP_HOLD_STRENGTH)
            end

            self.airborne = true 
            self.grounded = false
        elseif self.grounded == true then 
            self.jump_time = 0
            self.active_jump = false 
        end

        if GAME().core.input.is_input_active(C_INPUT_IDS.RIGHT) then 
            if GAME().core.input.is_input_active(C_INPUT_IDS.RIGHT,true) then 
                body:applyLinearImpulse(C_PLAYER_HORI_MOVE_SPEED*C_PLAYER_HORI_MOVE_START_SCALAR*(sprint_flag and 1.0 or C_PLAYER_WALK_SCALAR),0)
            end

            targx = targx + C_PLAYER_HORI_MOVE_SPEED
        end

        local correct_x_vel = C_PLAYER_HORI_MAX_MOVE_SPEED*(sprint_flag and 1.0 or C_PLAYER_WALK_SCALAR) - math.abs(x)

        if correct_x_vel < 0 then 
            targx = targx - (x < 0 and correct_x_vel or -correct_x_vel)
        end

        body:applyForce(targx,0)

        if y < 0 then 
            body:applyForce(0,250)
        end 

        if not (targx > 0 and x > 0 or targx < 0 and x < 0) then 
            body:applyForce(-x * 4,0)
        end

        if GAME().core.input.is_input_active(C_INPUT_IDS.DOWN) then 
            body:applyForce(0,C_PLAYER_DOWN_STRENGTH)
        end

        if body:getY() > 625 then 
            body:setY(-25)
        end
        if body:getY() < -25 then 
            body:setY(625)
        end

        if body:getX() < -25 then 
            body:setX(825)
        end
        if body:getX() > 825 then 
            body:setX(-25)
        end
    end,
    render = function(self, body) 
        love.graphics.push()
        local x,y = body:getPosition()
        love.graphics.setColor(255,0,0,255)
        love.graphics.translate(x,y)
        love.graphics.rotate(body:getAngle())
        love.graphics.rectangle("line", -25, -25, 50, 50)
        love.graphics.pop()
    end,
    on_collide = function(self, b_data, a, b, x, y, coll)
        if y > 0 then -- bottom face collided
            self.airborne = false 
            self.grounded = true 
            self.jump_time = 0    
        end
    end
}


return player 