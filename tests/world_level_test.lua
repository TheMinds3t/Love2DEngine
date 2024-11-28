
if GAME().world.start_world() then 
    local level = GAME().levelgen.load_level("LEVEL_TEST", 32, GAME().world.rand())

    local test_obj = GAME().physics.create_holder_from("PLAYER", level.start_x, level.start_y)
    local cam = GAME().camera.create_cam(C_CAMERA_MOVEMENT_TYPE.NORMAL_CURSOR,{target=test_obj.sprite})
end
