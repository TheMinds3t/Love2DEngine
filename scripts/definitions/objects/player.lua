require("scripts.core.constants")
local player = {
    init = function(self,x,y,params)
        self.phys = GAME().physics.new_rectangle(self,x,y,25,50,C_PHYSICS_BODY_TYPES.DYNAMIC)
        self.phys.fixture:setRestitution(0)
        self.phys.fixture:setDensity(0)
        self.phys.body:setFixedRotation(true)
        self.phys.body:setAngularDamping(1)
        self.phys.body:setLinearDamping(0)

        self.sprite = GAME().render.create_sprite("ENEMY_BAT")
        GAME().render.update_sprite(self.sprite, self, 0)
        self.get_hori_move_dir = function(self, body)
            local targx = 0

            if GAME().input.is_input_active(C_INPUT_IDS.LEFT) then 
                targx = targx - C_PLAYER_HORI_MOVE_SPEED
            end
    
            if GAME().input.is_input_active(C_INPUT_IDS.RIGHT) then 
                targx = targx + C_PLAYER_HORI_MOVE_SPEED
            end

            return targx, (self.sprinting and 1.0 or C_PLAYER_WALK_SCALAR)
        end
    end,
    update = function(self, dt, body)
        local move_scale = 1
        GAME().render.update_sprite(self.sprite, self, dt)
        -- local gravx,gravy = GAME().world.cur_world:getGravity()
        -- local targy = gravy
        -- jump
        if GAME().input.is_input_active(C_INPUT_IDS.JUMP) then
            if (self.airborne or false) == false then 
                -- targy = targy - C_PLAYER_JUMP_STRENGTH*move_scale
                body:applyLinearImpulse(0,-C_PLAYER_JUMP_STRENGTH*move_scale)                        
                self.active_jump = true 
            end

            self.jump_time = math.min((self.jump_time or 0) + dt, C_PLAYER_MAX_JUMP_TIME)

            if self.jump_time < C_PLAYER_MAX_JUMP_TIME and self.active_jump == true then 
                -- targy = targy - C_PLAYER_JUMP_HOLD_STRENGTH*move_scale
                body:applyLinearImpulse(0,-C_PLAYER_JUMP_HOLD_STRENGTH*move_scale*dt)
            end

            self.airborne = true 
            self.grounded = false
        elseif self.grounded == true then 
            self.jump_time = 0
            self.active_jump = false 
        end

        local targx, hori_move_scalar = self.get_hori_move_dir(self, body)
        local xvel, yvel = body:getLinearVelocity()

        if GAME().input.is_input_active(C_INPUT_IDS.DOWN) then 
            body:applyForce(0,C_PLAYER_DOWN_STRENGTH*move_scale)
        end

        body:applyLinearImpulse(targx*hori_move_scalar*dt,0)
        body:applyForce(targx*hori_move_scalar*dt,0)

        -- create responsive movement when inputs change 
        if targx == 0 then 
            self.initial_move_frame = true
        else 
            self.sprite.flipx = targx > 0

            if (self.sprinting or false) == false and (GAME().input.is_input_active(C_INPUT_IDS.SPRINT)) or self.initial_move_frame == true then 
                body:applyLinearImpulse(targx*hori_move_scalar,0)
                self.initial_move_frame = false 
            end    
        end
        self.sprinting = GAME().input.is_input_active(C_INPUT_IDS.SPRINT) == true
        
        -- stop movement when not moving 
        if not (targx > 0 and xvel > 0 or targx < 0 and xvel < 0) then 
            body:applyLinearImpulse(-xvel,0)
        end

        -- clamp horizontal movement speed 
        if math.abs(xvel) > C_PLAYER_HORI_MOVE_SPEED*hori_move_scalar then 
            local vel_diff = math.abs(xvel) - C_PLAYER_HORI_MOVE_SPEED*hori_move_scalar
            body:setLinearVelocity(xvel + vel_diff * (xvel > 0 and -1 or 1), yvel)
            -- body:applyForce(vel_diff * (xvel > 0 and -1 or 1), 0)
            local newvelx, newvely = body:getLinearVelocity()
        end

        if yvel < 0 then 
            body:applyForce(0,C_PLAYER_COUNTER_JUMP_FORCE*move_scale)
        end 

        if GAME().input.is_input_active(C_INPUT_IDS.SHOOT) and self.util.is_tick(self,10) then 
            local cam_pos = GAME().camera.get_position_in_cam(body:getX(),body:getY())
            local mouse_pos = GAME().camera.get_position_in_cam(GAME().input.mouse_x,GAME().input.mouse_y,true)
            local ang = (GAME().util.get_angle_towards(cam_pos.x, cam_pos.y, mouse_pos.x, mouse_pos.y, true) - 90) % 360
            GAME().physics.create_holder_from("BULLET",body:getX(),body:getY(),{angle=ang,velocity=20,source=self})
        end



        self.util.wrap_screen(self, body)
    end,
    render = function(self, body) 
        self.time = self.time or 0
        GAME().render.draw_sprite(self.sprite,0,{color_add=GAME().util.rainbow_color(self.time,0,5)})
    end,
    on_collide = function(self, b_data, a, b, x, y, coll)
        if y > 0 and math.abs(x) <= C_PLAYER_GROUND_CONNECT_THRES then -- bottom face collided
            self.airborne = false 
            self.grounded = true 
            self.jump_time = 0    
            local targx, hori_move_scalar = self.get_hori_move_dir(self, body)
            a:applyLinearImpulse(targx*hori_move_scalar,0)

        end
    end
}


return player 