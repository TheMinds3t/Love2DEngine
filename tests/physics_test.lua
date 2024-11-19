GAME().core.world.start_world()

local test_obj = GAME().core.physics.create_holder_from("TEST", 200, 200)

GAME().core.physics.create_holder_from("BLOCK", 200, 250, {width=200,height=50})
GAME().core.physics.create_holder_from("ROTATING_BLOCK", 600, 250, {width=100,height=100})
GAME().core.physics.create_holder_from("BLOCK", 400, 590, {width=1000,height=20})
GAME().core.physics.create_holder_from("RAINMAKER", 400, 25)
