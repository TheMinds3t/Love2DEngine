-- handles creating the physics objects from a file, stitches together different pieces 

local levelgen = {}

levelgen.init = function()
    for ind,id in pairs(GAME().registry.get_keys_for(C_REG_TYPES.LEVEL)) do 
        local lvl = GAME().registry.get_registry_object(C_REG_TYPES.LEVEL, id)
        lvl.max_height = 0
        lvl.min_width = 9999
        if lvl then 
            for i=1, #lvl.sections do 
                lvl.sections[i] = love.image.newImageData(lvl.sections[i])
                lvl.max_height = math.max(lvl.max_height, lvl.sections[i]:getHeight())
                lvl.min_width = math.min(lvl.min_width, lvl.sections[i]:getWidth())
            end
        end
    end
end

levelgen.get_pixel_key = function(id, x, y)
    local r,g,b,a = id:getPixel(x-1,y-1)
    return math.floor(r*255)..","..math.floor(g*255)..","..math.floor(b*255) 
end

levelgen.clear_pixel = function(id, x, y)
    id:setPixel(x-1,y-1,1,1,1,1)
end

levelgen.clean_collision_data_pixels = function(x,y,r,g,b,a)
    if a == 0 then 
        return 1,1,1,1
    else 
        return r,g,b,a
    end
end

levelgen.load_level = function(level_id, width, rand)
    local level = GAME().registry.get_registry_object(C_REG_TYPES.LEVEL, level_id)

    if level then 
        local cur_w = 0
        local max_y = 0
        local map_data = {}
        map_data.level = level
        local max_extended_width = math.ceil(width / level.min_width) * (level.min_width + (level.section_padding or 0))
        map_data.collision_data = love.image.newImageData(max_extended_width+2,level.max_height+2)
        map_data.collision_map = {}

        while cur_w < width do 
            -- select random section  
            local sec = level.sections[rand:random(1,#level.sections)]
            local sec_data = {}
            if sec then 
                --get section data 
                local id = sec:clone()
                local i_w, i_h = id:getDimensions()

                local pix_sec_w = 1
                local pix_sec_h = 1
                local y_off = level.max_height - id:getHeight()
                map_data.collision_data:paste(id,cur_w+1,y_off+1,0,0,id:getWidth(),id:getHeight())

                -- create from section details
                for y=1,i_h do 
                    for x=1,i_w do 
                        local key = levelgen.get_pixel_key(id,x,y)
                        local value = level.key[key]

                        if value then 
                            if value.no_group ~= true then 
                                -- reduce amount of objects in world by creating larger segments
                                while x+pix_sec_w <= i_w and levelgen.get_pixel_key(id,x+pix_sec_w,y) == key do 
                                    levelgen.clear_pixel(id,x+pix_sec_w,y)
                                    pix_sec_w = pix_sec_w + 1
                                end

                                -- if there is not a larger width, do a larger height!
                                if pix_sec_w == 1 then 
                                    while y+pix_sec_h <= i_h and levelgen.get_pixel_key(id,x,y+pix_sec_h) == key do 
                                        levelgen.clear_pixel(id,x,y+pix_sec_h)
                                        pix_sec_h = pix_sec_h + 1
                                    end
                                end
                            end

                            if value.populate then 
                                value.populate(map_data, sec_data,
                                (cur_w+x+0.5+pix_sec_w/2.0)*C_LEVEL_TILE_SIZE, 
                                (y+0.5+pix_sec_h/2.0-level.max_height+y_off)*C_LEVEL_TILE_SIZE, 
                                pix_sec_w, pix_sec_h, rand)    
                            end

                            x = x + pix_sec_w
                            pix_sec_w = 1
                            pix_sec_h = 1
                        end
                    end
                end

                cur_w = cur_w + i_w + (level.section_padding or 0)
                max_y = math.max(max_y, i_h)
                id:release()
                map_data.section_data = map_data.section_data or {}
                table.insert(map_data.section_data, sec_data)
            else 
                GAME().log("INVALID SECTION for level \'"..level_id.."\'...", C_LOGGER_LEVELS.ERROR)
            end

            map_data.section_data = map_data.section_data or {}
        end
        
        cur_w = cur_w
        GAME().log(level.max_height..","..max_y)

        level.create_floor(map_data, 
            (cur_w+3) / 2.0 * C_LEVEL_TILE_SIZE, 
            (1) * C_LEVEL_TILE_SIZE, 
            cur_w+C_LEVEL_FLOOR_LIP_SIZE*2, max_y, rand)

        map_data.collision_data:mapPixel(levelgen.clean_collision_data_pixels)
        fd = map_data.collision_data:encode("png","testing_image.png")
        GAME().log(fd:getFilename())

        return map_data
    end 
end

return levelgen