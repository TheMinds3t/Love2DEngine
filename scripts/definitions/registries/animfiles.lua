return {
    clone_on_create = false,
    entries = {
        ENEMY_BAT = GAME().filehelper.load_file("scripts/definitions/anim_files/enemy/anim_bat.lua"),
        ENEMY_BARTOX = GAME().filehelper.load_file("scripts/definitions/anim_files/enemy/anim_big_bat.lua"),
        ENEMY_SPIDER = GAME().filehelper.load_file("scripts/definitions/anim_files/enemy/anim_spider.lua"),
        UI_BUFFER_WHEEL = GAME().filehelper.load_file("scripts/definitions/anim_files/ui/anim_buffer.lua"),
        BULLET_NORMAL = GAME().filehelper.load_file("scripts/definitions/anim_files/anim_bullet.lua"),
        FX_BLOOD_EXPLODE = GAME().filehelper.load_file("scripts/definitions/anim_files/effect/anim_blood_explode.lua"),
    }
}