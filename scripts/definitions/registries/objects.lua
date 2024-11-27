require("scripts.core.constants")

return {
    clone_on_create = true,
    entries = {
        PLAYER = GAME().filehelper.load_file("scripts/definitions/objects/player.lua"),
        BULLET = GAME().filehelper.load_file("scripts/definitions/objects/bullet.lua"),
        ENEMY_BAT = GAME().filehelper.load_file("scripts/definitions/objects/enemy/bat/bat_base.lua"),
        ENEMY_BARTOX = GAME().filehelper.load_file("scripts/definitions/objects/enemy/bat/big_bat.lua"),
        ENEMY_SPIDER = GAME().filehelper.load_file("scripts/definitions/objects/enemy/spider/spider_base.lua"),
        BLOCK = {
            wall = true,
            init = function(self,x,y,params)
                self.width = params.width or 200
                self.height = params.height or 50
                self.rot = params.rot or 0
                self.phys = GAME().physics.new_rectangle(self,x,y,self.width,self.height,C_PHYSICS_BODY_TYPES.STATIC)
                self.mesh = GAME().render.create_mesh("MESH_GRASS", self.width, self.height)
                self.mesh.x = x 
                self.mesh.y = y 
                self.mesh.rot = self.rot
                self.phys.body:setAngle(math.rad(self.rot))
            end,
            render = function(self, body) 
                GAME().render.draw_mesh(self.mesh)
            end,
        },
        LIVE_BLOCK = {
            wall = true,
            init = function(self,x,y,params)
                self.width = params.width or 200
                self.height = params.height or 50
                self.phys = GAME().physics.new_rectangle(self,x,y,self.width,self.height,C_PHYSICS_BODY_TYPES.STATIC)
                self.mesh = GAME().render.create_mesh("MESH_GRASS", self.width, self.height)
                self.mesh.x = x 
                self.mesh.y = y 
                self.update_logic = params.update or function(self,dt,body)
                    body:setAngle(math.cos(self.time or 0)/ 16.0)
                    self.mesh.rot = math.deg(body:getAngle())    
                end
            end,
            update = function(self, dt, body)
                if self.update_logic then 
                    self.update_logic(self,dt,body)
                end
            end,
            render = function(self, body) 
                GAME().render.draw_mesh(self.mesh)
            end,
        },
        EFFECT = {
            init = function(self,x,y,params)
                params.sprite = params.sprite == nil and "BULLET_NORMAL" or params.sprite
                params.anim_name = params.anim_name == nil and "effect" or params.anim_name
                params.rot = params.rot == nil and 0 or params.rot
                params.gravity_scale = params.gravity_scale == nil and 0 or params.gravity_scale
                self.params = params 
                self.phys = GAME().physics.new_rectangle(self,x,y,25,25,C_PHYSICS_BODY_TYPES.DYNAMIC)
                self.phys.body:setGravityScale(params.gravity_scale)
                self.sprite = GAME().render.create_sprite(params.sprite)
                self.sprite.cur_anim = params.anim_name
                GAME().render.update_sprite(self.sprite, self, 0)
                self.contact_type = params.contact_type == nil and C_WORLD_CONTACT_TYPES.NONE or params.contact_type
            end,
            update = function(self, dt, body)
                GAME().render.update_sprite(self.sprite, self, dt)

                if self.params.angle then 
                    self.sprite.rot = self.params.angle 

                    if self.params.velocity then 
                        body:setLinearVelocity(math.cos(self.params.angle) * self.params.velocity * C_WORLD_METER_SCALE, math.sin(self.params.angle) * self.params.velocity * C_WORLD_METER_SCALE)
                    end
                end

                if self.params.update then 
                    self.params.update(self, dt, body)
                end

                if GAME().render.sprite_animation_finished(self.sprite) then 
                    self.destroy = true 
                end
            end,
            render = function(self, body) 
                GAME().render.draw_sprite(self.sprite,0)
            end
        }
    }
}