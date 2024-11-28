local bat = GAME().util.deep_copy(GAME().filehelper.load_file("scripts/definitions/objects/enemy/bat/bat_base.lua"))
bat.max_move_speed = 20
bat.off_update_dampener = 0.3
bat.death_fx = {sprite="FX_BLOOD_EXPLODE", anim_name="explode_large"}
bat.attack_anim = "fly"
bat.sprite = "ENEMY_BARTOX"
bat.move_speed = 8
bat.size = {width=80,height=80}
bat.max_health = 5
bat.charge_time = 3.0
bat.charge_dist = 300
bat.charge_tell_time = 1.0

bat.position_offset = function(self,dt,body)
    if self.charging then 
        return {
            x = (self.charge_dir and -self.charge_dist or self.charge_dist) * (self.sprite.cur_anim == "charge" and -1 or 1), 
            y = 16}
    else
        return {
            x = math.cos(self.time + self.index * 127.5) * 100 + math.sin(self.time * 6.2 + self.index * 10.5) * 10, 
            y = math.cos(self.time * 4.7 + self.index * 127.5) * 25 + math.sin(self.time * 2.25 + self.index * 57.5) * 50 - 150}    
    end
end

-- local sup_update = bat.update

-- bat.update = function(self, dt, body)
--     sup_update(self,dt,body)
-- end

bat.bat_update = function(self, dt, body)
    if GAME().render.sprite_event_triggered(self.sprite, "big_flap") then 
        GAME().audio.play("FLAP",1.0,1.0)
    end

    if self.target then 
        if self.charging then
            self.sprite.flipx = self.charge_dir

            if self.sprite.cur_anim ~= "charge" then
                self.charge_tell = (self.charge_tell or 0) + dt  
                if self.charge_tell >= self.charge_tell_time and math.abs(self.target.y - self.y) < 32 and math.abs(self.target.x - self.x) > self.charge_dist * 0.75 then 
                    GAME().render.start_animation(self.sprite,"charge") 
                    self.charge_tell = 0
                end
            else 
                self.only_collide_list["BLOCK"] = false
                self.only_collide_list["LIVE_BLOCK"] = false
                if self.util.is_tick(self, 3) then 
                    GAME().physics.create_holder_from("BULLET",self.x,self.y,{
                        angle=((self.charge_dir and 0 or 180) + (GAME().world.rand():random(1,90)-45)) % 360, 
                        velocity=5, lifetime=1,
                        source=self})
                end

                self.charge_time = math.min(self.charge_time,self.charge_tell_time) - dt 
                self.charging = self.charge_time > 0.0    
            end
        else 
            self.only_collide_list["BLOCK"] = true
            self.only_collide_list["LIVE_BLOCK"] = true

            self.charge_time = (self.charge_time or 0) + dt
            self.charging = self.charge_time > bat.charge_time
    
            if self.charging then 
                self.charge_dir = self.sprite.flipx 
            end
    
            if self.sprite.cur_anim ~= "fly" then 
                GAME().render.start_animation(self.sprite,"fly") 
            end        
        end    
    end
end

return bat 