require("scripts.core.constants")
return {
    clone_on_create = true,
    entries = {
        ENEMY_BAT = {
            anim_file = "ENEMY_BAT",
            default_anim = "fly",
            healthbar_offset = {x=0,y=50},
            healthbar_dims = {width=32,height=3}
        },
        UI_BUFFER_WHEEL = {
            anim_file = "UI_BUFFER_WHEEL",
            default_anim = "buffer",
        },
        BULLET_NORMAL = {
            anim_file = "BULLET_NORMAL",
            default_anim = "bullet",
        }
    }
}