GAME().core.world.start_world()

local test_obj = GAME().core.physics.create_holder_from("TEST", 200, 200)

GAME().core.physics.create_holder_from("BLOCK", 200, 350)
GAME().core.physics.create_holder_from("BLOCK", 600, 350)
GAME().core.physics.create_holder_from("ROTATING_BLOCK", 400, 500)
