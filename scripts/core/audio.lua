local audio = {}
audio.active_sounds = {}
audio.rand = love.math.newRandomGenerator()

audio.play = function(sfx_id, vol, pitch)
    vol = vol == nil and 1.0 or vol 
    pitch = pitch == nil and 1.0 or pitch 

    local sfx = GAME().registry.get_registry_object(C_REG_TYPES.SOUND, sfx_id)

    if sfx then 
        local active = {obj=sfx,sel=math.floor(os.clock()*1000)%#sfx + 1}
        if active.obj[active.sel].source ~= nil then 
            active.source = active.obj[active.sel].source:clone() 
            active.pitch = pitch * audio.rand:random(math.floor((active.obj[active.sel].pitch_range.min or 1.0)*100),math.floor((active.obj[active.sel].pitch_range.max or 1.0)*100)) / 100.0
            active.volume = vol * (active.obj[active.sel].volume_mult or 1.0)
            active.source:setPitch(active.pitch)
            active.source:setVolume(active.volume)

            local slot = audio.get_sfx_slot()
            GAME().log("slot="..slot)
            audio.active_sounds[slot] = active
            love.audio.play(active.source)
            GAME().log("Played sound \'"..sfx_id.."\' (volume="..active.volume..",pitch="..active.pitch..")", C_LOGGER_LEVELS.INFO)
        else 
            GAME().log("Source \'"..sfx_id.."\' is invalid!! Not playing...", C_LOGGER_LEVELS.ERROR)
        end
    else
        GAME().log("Cannot identify sound \'"..sfx_id.."\', not playing...", C_LOGGER_LEVELS.ERROR)
    end
end

audio.get_sfx_slot = function()
    for i=1,C_AUDIO_MAX_SFX_SOURCES do 
        local sfx = audio.active_sounds[i]
        if sfx == nil or not sfx.source:isPlaying() then 
            return i 
        end
    end

    return math.floor(os.clock() * 1000) % C_AUDIO_MAX_SFX_SOURCES
end

audio.update = function(dt)
    for i=C_AUDIO_MAX_SFX_SOURCES,1,-1 do 
        local sfx = audio.active_sounds[i]
        if sfx ~= nil and not sfx.source:isPlaying() then 
            sfx.source:release()
            audio.active_sounds[i] = nil 
        end
    end
end

return audio 