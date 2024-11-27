

local bat = {
    -- mark this object as an enemy 
    enemy = true,
    -- only can collide with these object IDs
    contact_type = C_WORLD_CONTACT_TYPES.ONLY_IN_LIST,
    only_collide_list = {
        ["BLOCK"] = true,
        ["LIVE_BLOCK"] = true,
        ["BULLET"] = true,
    },

    -- maximum movement speed per second 
    move_speed = 4,
    max_move_speed = 5,
    -- take this many seconds to change positions
    off_update_dampener = 0.5,
    max_health = 4,
    attack_anim = "attack",
    idle_anim = "fly",
    sprite = "ENEMY_BAT",

    min_attack_time = 120,
    max_attack_time = 180,

    death_fx = {sprite="FX_BLOOD_EXPLODE", anim_name="explode"},
    size = {width=22,height=50},

    position_offset = function(self, dt, body) 
        return {
            x = math.cos(self.time + self.index * 127.5) * 100 + math.sin(self.time * 6.2 + self.index * 10.5) * 10, 
            y = math.cos(self.time * 4.7 + self.index * 127.5) * 25 + math.sin(self.time * 2.25 + self.index * 57.5) * 50 - 150}
    end,

    fire = function(self, dt, body) 
        local targvelx, targvely = self.target.phys.body:getLinearVelocity()
        local ang = GAME().util.get_angle_towards(body:getX(), body:getY(), self.target.phys.body:getX() + targvelx / 5.0, self.target.phys.body:getY(), true)
        GAME().physics.create_holder_from("BULLET",body:getX(),body:getY(),{angle=ang,velocity=10,source=self,lifetime=1.5})
    end,

    on_remove = function(self, body)
        GAME().physics.create_holder_from("EFFECT",body:getX(),body:getY(),
        {
            sprite=self.death_fx.sprite,
            anim_name=self.death_fx.anim_name, 
        })
    end,

    -- create default values per bat 
    construct_params = function(self, params)
        params.health = params.health == nil and self.max_health or params.health
        params.sprite = params.sprite == nil and self.sprite or params.sprite
        params.speed = params.speed == nil and self.move_speed or params.speed 
        params.pos_offset = params.pos_offset == nil and self.position_offset or params.pos_offset
        params.fire = params.fire == nil and self.fire or params.fire 
        return params 
    end,

    init = function(self, x, y, params)
        self.phys = GAME().physics.new_rectangle(self,x,y,self.size.width,self.size.height,C_PHYSICS_BODY_TYPES.DYNAMIC)
        self.phys.body:setFixedRotation(true)
        self.phys.body:setGravityScale(0.0)
        self.params = self.construct_params(self, params)
        GAME().physics.add_life_data(self, params.health)
        self.sprite = GAME().render.create_sprite(self.params.sprite)
        GAME().render.update_sprite(self.sprite, self, 0)
    end,
    update = function(self, dt, body)
        if self.util.is_tick(self, 60, self.index * 4) then 
            GAME().physics.set_target(self)
        end

        GAME().render.update_sprite(self.sprite, self, dt)

        if GAME().render.sprite_event_triggered(self.sprite, "flap") then 
            GAME().audio.play("FLAP",0.5,1.5)
        end

        if self.target ~= nil then 
            self.target_time = (self.target_time or 0) + dt
            local off = self.params.pos_offset(self, dt, body)
            self.cur_off_x = ((self.cur_off_x or body:getX()) * self.off_update_dampener + (self.target.phys.body:getX() + off.x) * dt) / (self.off_update_dampener + dt)
            self.cur_off_y = ((self.cur_off_y or body:getY()) * self.off_update_dampener + (self.target.phys.body:getY() + off.y) * dt) / (self.off_update_dampener + dt)

            self.sprite.flipx = body:getX() < self.target.phys.body:getX()

            local dist = GAME().util.get_distance(
                body:getX(), body:getY(),
                self.cur_off_x,
                self.cur_off_y)
            local ang = GAME().util.get_angle_towards(
                body:getX(), body:getY(),
                self.cur_off_x,
                self.cur_off_y)

            local spd = math.min(self.max_move_speed * C_WORLD_METER_SCALE, dist * self.params.speed)
            
            if self.util.is_tick(self, math.min(self.min_attack_time, self.max_attack_time - math.floor(self.target_time * 6)), self.index * 5) and self.attack_anim ~= self.idle_anim then 
                GAME().render.start_animation(self.sprite,self.attack_anim)
            end

            if GAME().render.sprite_event_triggered(self.sprite, "fire") and self.sprite.cur_anim == "attack" then 
                self.params.fire(self,dt,body)
            end

            body:setLinearVelocity(math.cos(ang) * spd, math.sin(ang) * spd)
        else 
            self.target_time = 0
        end
        
        if self.bat_update ~= nil then 
            self.bat_update(self, dt, body)
        end

        if GAME().render.sprite_animation_finished(self.sprite) then 
            GAME().render.start_animation(self.sprite,self.idle_anim)
        end
    end,
    bullet_collide = function(self, b_data, x, y)
        self.hurt_time = C_RENDER_MAX_HURT_TIME * 2
        self.health = self.health - 1 

        if self.health <= 0 then 
            self.destroy = true 
        end

        self.next_tick = function() 
            GAME().physics.create_holder_from("EFFECT",
            b_data.x,
            b_data.y,
            {
                sprite="FX_BLOOD_EXPLODE",
                anim_name="explode_tiny", 
                angle = b_data.params.angle,
                velocity = -2
            })
        end
    end,
    render = function(self, body)
        GAME().render.draw_sprite(self.sprite)

        -- if self.target then 
        --     local off = self.params.pos_offset(self, dt, body)

        --     love.graphics.push()
        --     love.graphics.setColor(1,0,0,1)
        --     love.graphics.ellipse("fill", (self.cur_off_x), (self.cur_off_y), 5, 5)
        --     love.graphics.pop()    
        -- end
    end
}

return bat 