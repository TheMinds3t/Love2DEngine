local level = {}

level.sections = {
    "resources/map/section/test_loop.png",
    "resources/map/section/cage.png",
    "resources/map/section/nest.png",
    "resources/map/section/peeper.png",
}

level.section_padding = 1

level.create_floor = function(map_data,x,y,w,h,rand)
    map_data.start_x = x 
    map_data.start_y = y - C_LEVEL_TILE_SIZE * 2
    GAME().physics.create_holder_from("BLOCK",
        x,
        y+C_LEVEL_TILE_SIZE+C_WINDOW_DIMENSIONS.HEIGHT,
        {
            width= w*C_LEVEL_TILE_SIZE,
            height= C_LEVEL_TILE_SIZE + C_WINDOW_DIMENSIONS.HEIGHT * 2
        })
end

level.key = {
    ["0,0,0"] = {
        wall = true,
        populate = function(map_data,sec_data,x,y,t_width,t_height,rand)
            GAME().physics.create_holder_from("BLOCK", x, y, 
                {width=C_LEVEL_TILE_SIZE*t_width,height=C_LEVEL_TILE_SIZE*t_height})
        end
    },
    ["255,0,0"] = {
        wall = false,
        no_group = true,
        populate = function(map_data,sec_data,x,y,t_width,t_height,rand)
            sec_data.enemies = sec_data.enemies or {}
            local bat = GAME().physics.create_holder_from("ENEMY_BAT", x, y)
            table.insert(sec_data.enemies, bat)        
        end
    },
    ["255,0,255"] = {
        wall = false,
        no_group = true,
        populate = function(map_data,sec_data,x,y,t_width,t_height,rand)
            sec_data.enemies = sec_data.enemies or {}
            local bat = GAME().physics.create_holder_from("ENEMY_BARTOX", x, y)
            table.insert(sec_data.enemies, bat)
        end
    },
    ["0,0,255"] = {
        wall = true,
        populate = function(map_data,sec_data,x,y,t_width,t_height,rand)
            local live = GAME().physics.create_holder_from("LIVE_BLOCK", x, y, {
                width=C_LEVEL_TILE_SIZE*t_width,height=C_LEVEL_TILE_SIZE*t_height,
                update=function(self,dt,body)
                    if sec_data.enemies then 
                        if self.util.is_tick(self,33,2) then 
                            local destroy_flag = #sec_data.enemies
                            local lock_flag = false 
                            for _,en in ipairs(sec_data.enemies) do 
                                if en ~= nil then 
                                    if en.destroy == true then 
                                        destroy_flag = destroy_flag - 1
                                    end
    
                                    if en.active == true then 
                                        lock_flag = true 
                                    end
                                end
                            end
                            
                            self.mesh.visible = lock_flag 
    
                            if destroy_flag <= 0 then 
                                self.destroy = true 
                            elseif lock_flag then 
                                self.contact_type = C_WORLD_CONTACT_TYPES.ALL
                            else 
                                self.contact_type = C_WORLD_CONTACT_TYPES.NONE
                            end
                        end    
                    end
                end
            })
        end
    },
    ["0,255,0"] = {
        wall = true,
        populate = function(map_data,sec_data,x,y,t_width,t_height,rand)
            local live = GAME().physics.create_holder_from("LIVE_BLOCK", x, y, {
                width=C_LEVEL_TILE_SIZE*t_width,height=C_LEVEL_TILE_SIZE*t_height,
                update=function(self,dt,body)
                    if sec_data.enemies then 
                        if self.util.is_tick(self,33,2) then 
                            local destroy_flag = #sec_data.enemies
                            local lock_flag = true 
                            for _,en in ipairs(sec_data.enemies) do 
                                if en ~= nil then 
                                    if en.active == true and en.destroy ~= true then 
                                        lock_flag = false  
                                    end
                                end
                            end
                            
                            self.mesh.visible = lock_flag 
                            
                            if lock_flag then 
                                self.contact_type = C_WORLD_CONTACT_TYPES.ALL
                            else 
                                self.contact_type = C_WORLD_CONTACT_TYPES.NONE
                            end
                        end    
                    end
                end
            })
        end
    },
}


return level 