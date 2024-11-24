return {
    clone_on_create = false,
    entries = {
        ENEMY_BAT = GAME().filehelper.load_file("scripts/definitions/anim_files/anim_bat.lua"),
        UI_BUFFER_WHEEL = GAME().filehelper.load_file("scripts/definitions/anim_files/ui/anim_buffer.lua"),
        BULLET_NORMAL = GAME().filehelper.load_file("scripts/definitions/anim_files/anim_bullet.lua"),
    }
}