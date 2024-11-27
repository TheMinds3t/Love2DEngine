require("scripts.core.constants")
local bullet = {
    bullet = true,
    contact_type = C_WORLD_CONTACT_TYPES.DYNAMIC,
    create_params = function(params)
        params = params or {}
        params.angle = params.angle == nil and 0 or params.angle
        params.velocity = params.velocity == nil and 1 or params.velocity
        params.lifetime = params.lifetime == nil and 5 or params.lifetime
        params.sprite = params.sprite == nil and "BULLET_NORMAL" or params.sprite
        params.fx_vel_scale = params.fx_vel_scale == nil and 0.0 or params.fx_vel_scale
        params.mass = params.mass == nil and 0.1 or params.mass
        params.wall_collide = params.wall_collide == nil and true or params.wall_collide
        params.die_with_source = params.die_with_source == nil and true or params.die_with_source
        return params 
    end,
    init = function(self,x,y,params)
        self.phys = GAME().physics.new_rectangle(self,x,y,10,10,C_PHYSICS_BODY_TYPES.DYNAMIC)
        self.phys.body:setFixedRotation(true)
        self.phys.body:setBullet(true)
        self.params = self.create_params(params)
        self.phys.body:setMass(self.params.mass)
        self.sprite = GAME().render.create_sprite(params.sprite)
        GAME().render.update_sprite(self.sprite, self, 0)
    end,
    update = function(self, dt, body)
        local move_scale = 1
        GAME().render.update_sprite(self.sprite, self, dt)
        self.sprite.rot = self.params.angle

        body:setLinearVelocity(
            math.cos(math.rad(self.params.angle)) * self.params.velocity * C_WORLD_METER_SCALE, 
            math.sin(math.rad(self.params.angle)) * self.params.velocity * C_WORLD_METER_SCALE)

        if self.time > self.params.lifetime or (self.params.source ~= nil and self.params.source.destroy == true and self.params.die_with_source == true) then 
            self.destroy = true 
        end

        if self.params.update ~= nil then 
            self.params.update(self, dt, body)
        end
    end,
    render = function(self, body) 
        self.time = self.time or 0
        GAME().render.draw_sprite(self.sprite,0,{x_scale=(self.sprite.flipx and -1 or 1)})
    end,
    on_collide = function(self, b_data, a, b, x, y, coll)
        if b_data.bullet_collide then 
            b_data.bullet_collide(b_data, self, x, y)
        end

        self.destroy = true
    end,
    should_collide = function(self, b_dt, a, b)
        return b_dt.id ~= self.id and (b_dt.wall == true and self.params.wall_collide == true 
            or self.params.source == nil or 
            (b_dt.id == "PLAYER" and not self.params.source.is_player 
                or b_dt.enemy == true and self.params.source.is_player ))
    end,
    on_remove = function(self,body)
        GAME().physics.create_holder_from("EFFECT",body:getX(),body:getY(),
        {
            sprite=self.params.sprite, 
            angle=self.params.angle, 
            velocity=self.params.velocity*self.params.fx_vel_scale
        })
    end
}


return bullet 