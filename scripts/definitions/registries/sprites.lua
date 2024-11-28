require("scripts.core.constants")
return {
    clone_on_create = true,
    entries = {
        ENEMY_BAT = {
            anim_file = "ENEMY_BAT",
            default_anim = "fly",
            healthbar_offset = {x=0,y=40},
            healthbar_dims = {width=32,height=3},
            off_y = -8
        },
        ENEMY_BARTOX = {
            anim_file = "ENEMY_BARTOX",
            default_anim = "fly",
            healthbar_offset = {x=0,y=60},
            healthbar_dims = {width=64,height=5}
        },
        UI_BUFFER_WHEEL = {
            anim_file = "UI_BUFFER_WHEEL",
            default_anim = "buffer",
        },
        BULLET_NORMAL = {
            anim_file = "BULLET_NORMAL",
            default_anim = "bullet",
        },
        ENEMY_SPIDER = {
            anim_file = "ENEMY_SPIDER",
            default_anim = "idle",
            healthbar_offset = {x=0,y=40},
            healthbar_dims = {width=32,height=3}
        },
        FX_BLOOD_EXPLODE = {
            anim_file = "FX_BLOOD_EXPLODE",
            default_anim = "explode",
        },
    }
}