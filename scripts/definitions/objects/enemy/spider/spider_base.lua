

local spider = {
    -- mark this object as an enemy 
    enemy = true,
    -- only can collide with these object IDs
    contact_type = C_WORLD_CONTACT_TYPES.ONLY_IN_LIST,
    only_collide_list = {
        ["BLOCK"] = true,
        ["LIVE_BLOCK"] = true,
        ["BULLET"] = true,
    },
    off_update_dampener = 0.2,
    max_move_speed = 5 * C_WORLD_METER_SCALE,
    -- create default values per bat 
    construct_params = function(params)
        params.health = params.health == nil and 15 or params.health
        params.sprite = params.sprite == nil and "ENEMY_SPIDER" or params.sprite
        params.speed = params.speed == nil and 5 or params.speed 
        params.bullet_count = params.bullet_count == nil and 12 or params.bullet_count
        params.pos_offset = params.pos_offset == nil and function(self, dt, body) 
            return {
                x = 0, 
                y = math.cos(self.time * 2.7 + self.index * 127.5) * 25 + math.sin(self.time * 1.25 + self.index * 57.5) * 100}
        end or params.pos_offset
        params.fire = params.fire == nil and function(self, dt, body) 
            local targvelx, targvely = self.target.phys.body:getLinearVelocity()

            for i=1,self.params.bullet_count do 
                local ang = GAME().util.get_angle_towards(body:getX(), body:getY(), self.target.phys.body:getX(), self.target.phys.body:getY(), true) + (i * (360 / self.params.bullet_count))
                GAME().physics.create_holder_from("BULLET",body:getX(),body:getY(),{angle=ang,velocity=11,source=self,lifetime=1.25,wall_collide=false,update=function(self,dt,body)
                    self.params.angle = self.params.angle + dt / 3.0 * 360.0
                end})
            end

        end or params.fire 
        return params 
    end,

    init = function(self, x, y, params)
        self.phys = GAME().physics.new_rectangle(self,x,y,22,50,C_PHYSICS_BODY_TYPES.DYNAMIC)
        self.phys.body:setFixedRotation(true)
        self.phys.body:setGravityScale(0.0)
        self.params = self.construct_params(params)
        self.origin = {x=x,y=y}
        GAME().physics.add_life_data(self, params.health)
        self.sprite = GAME().render.create_sprite(self.params.sprite)
        GAME().render.update_sprite(self.sprite, self, 0)
    end,
    update = function(self, dt, body)
        if self.util.is_tick(self, 60, self.index * 4) then 
            GAME().physics.set_target(self)
        end

        GAME().render.update_sprite(self.sprite, self, dt)

        if self.target ~= nil then 
            self.target_time = math.min((self.target_time or 0) + dt, 10)
            local off = self.params.pos_offset(self, dt, body)
            self.cur_off_x = ((self.cur_off_x or body:getX()) * self.off_update_dampener + (self.origin.x + off.x) * dt) / (self.off_update_dampener + dt)
            self.cur_off_y = ((self.cur_off_y or body:getY()) * self.off_update_dampener + (self.origin.y + off.y) * dt) / (self.off_update_dampener + dt)

            local dist = GAME().util.get_distance(
                body:getX(), body:getY(),
                self.cur_off_x,
                self.cur_off_y)
            local ang = GAME().util.get_angle_towards(
                body:getX(), body:getY(),
                self.cur_off_x,
                self.cur_off_y)

            local spd = math.min(self.max_move_speed, dist * self.params.speed)
            
            if self.util.is_tick(self, 241 - math.floor(self.target_time * 3), self.index * 5) then 
                GAME().render.start_animation(self.sprite,"attack")
            end

            if GAME().render.get_sprite_event(self.sprite) == "fire" and self.sprite.cur_anim == "attack" then 
                self.params.fire(self,dt,body)
            end

            body:setLinearVelocity(math.cos(ang) * spd, math.sin(ang) * spd)
        else 
            self.target_time = 0
        end

        if GAME().render.sprite_animation_finished(self.sprite) then 
            GAME().render.start_animation(self.sprite,"idle")
        end
    end,
    bullet_collide = function(self, b_data)
        self.hurt_time = C_RENDER_MAX_HURT_TIME * 2
        self.health = self.health - 1 

        if self.health <= 0 then 
            self.next_tick = function() self.destroy = true end
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

return spider 