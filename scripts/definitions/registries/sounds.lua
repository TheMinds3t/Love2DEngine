return {
    clone_on_create = false,
    entries = {
        FLAP = {
            {
                source = love.audio.newSource("resources/sfx/flap.wav", "static"),
                pitch_range = {min=0.8,max=1.1},
                volume_mult = 1.0
            },
        },
    }
}