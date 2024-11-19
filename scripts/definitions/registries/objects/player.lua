require("scripts.core.constants")
local player = {
    init = function(self,x,y)
        self.phys = GAME().core.physics.new_rectangle(self,x,y,50,50,C_PHYSICS_BODY_TYPES.DYNAMIC)
        self.phys.fixture:setRestitution(0)
        self.phys.fixture:setDensity(0)
        self.phys.body:setFixedRotation(true)

        self.sprite = GAME().core.render.create_sprite("ENEMY_BAT")
    end,
    max_jump_time = C_PLAYER_MAX_JUMP_TIME,
    update = function(self, dt, body)
        local move_scale = 1
        GAME().core.render.update_sprite(self.sprite, self, dt)

        local targx = 0
        local sprint_flag = GAME().core.input.is_input_active(C_INPUT_IDS.SPRINT)
        local hori_move_scalar = (sprint_flag == true and 1.0 or C_PLAYER_WALK_SCALAR) * move_scale
        local initial_move_frame = false

        if GAME().core.input.is_input_active(C_INPUT_IDS.LEFT) then 
            if GAME().core.input.is_input_active(C_INPUT_IDS.LEFT,true) then 
                initial_move_frame = true 
            end

            targx = targx - C_PLAYER_HORI_MOVE_SPEED
        end

        if GAME().core.input.is_input_active(C_INPUT_IDS.RIGHT) then 
            if GAME().core.input.is_input_active(C_INPUT_IDS.RIGHT,true) then 
                initial_move_frame = true 
            end

            targx = targx + C_PLAYER_HORI_MOVE_SPEED
        end

        -- jump
        if GAME().core.input.is_input_active(C_INPUT_IDS.JUMP) then
            if (self.airborne or false) == false then 
                body:applyLinearImpulse(0,-C_PLAYER_JUMP_STRENGTH*move_scale)                        
                self.active_jump = true 
                GAME().log("JUMP")
            end

            self.jump_time = math.min((self.jump_time or 0) + dt, self.max_jump_time)

            if self.jump_time < self.max_jump_time and self.active_jump == true then 
                body:applyLinearImpulse(0,-C_PLAYER_JUMP_HOLD_STRENGTH*move_scale*dt)
            end

            self.airborne = true 
            self.grounded = false
        elseif self.grounded == true then 
            self.jump_time = 0
            self.active_jump = false 
        end

        local xvel, yvel = body:getLinearVelocity()

        if math.abs(xvel) > C_PLAYER_HORI_MOVE_SPEED*hori_move_scalar*C_WORLD_METER_SCALE then 
            local vel_diff = math.abs(xvel) - C_PLAYER_HORI_MOVE_SPEED*hori_move_scalar*C_WORLD_METER_SCALE
            body:applyLinearImpulse(vel_diff * (xvel > 0 and -1 or 1), 0)
            body:applyForce(vel_diff * (xvel > 0 and -1 or 1), 0)
            local newvelx, newvely = body:getLinearVelocity()
        end

        -- local correct_x_vel = C_PLAYER_HORI_MAX_MOVE_SPEED*(sprint_flag and 1.0 or C_PLAYER_WALK_SCALAR)*move_scale - math.abs(x)

        -- if correct_x_vel < 0 then 
        --     targx = targx - (x < 0 and correct_x_vel or -correct_x_vel)
        -- end

        if initial_move_frame == true then 
            body:applyLinearImpulse(targx*hori_move_scalar,0)
            body:applyLinearImpulse(targx*hori_move_scalar,0)
        end

        body:applyLinearImpulse(targx*hori_move_scalar*dt,0)
        body:applyForce(targx*hori_move_scalar*dt,0)

        -- if yvel < 0 then 
        --     body:applyForce(0,C_PLAYER_COUNTER_JUMP_FORCE*move_scale)
        -- end 

        if not (targx > 0 and xvel > 0 or targx < 0 and xvel < 0) then 
            body:applyLinearImpulse(-xvel,0)
        end


        if GAME().core.input.is_input_active(C_INPUT_IDS.DOWN) then 
            body:applyForce(0,C_PLAYER_DOWN_STRENGTH*move_scale)
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
        love.graphics.translate(5,5)
        GAME().core.render.draw_sprite(self.sprite)
        love.graphics.translate(-5,-5)

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