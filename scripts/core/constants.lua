-- how many ticks should elapse in 1 second
C_TICKS_PER_SECOND = 60.0
C_MAX_DELTA_ALLOWED = 1 / C_TICKS_PER_SECOND * 5

C_GAMENAME = "demonical"

-- serializer keyterms
C_FH_SERIAL_CONNECT = "="
C_FH_SERIAL_TABLE_START = "{"
C_FH_SERIAL_TABLE_END = "}"
C_FH_SERIAL_DELIM = ","

-- separate animation layers so certain ones can be paused/unpaused
C_RENDER_LAYERS = {
    BACKGROUND=1, -- background
    INGAME=2, -- ingame 
    HUD=3, -- ingame hud
    MENU=4, -- menu graphics
    BUFFER=5 -- loading screen
}

-- what type of interpolation to generate for the animation
C_RENDER_INTERPOLATE_TYPE = {
    NONE = 1, --no interpolation
    NORMAL = 2, --interpolate transform
    UV = 3, --interpolate transform and uv quad
}

-- scale factor for all rendered sprites
C_RENDER_ROOT_SPRITE_SCALE = 2
-- default color when color is unspecified
C_COLOR_WHITE = {r=255,g=255,b=255,a=255}
C_COLOR_EMPTY = {r=0,g=0,b=0,a=0}

-- love.threads channel identifiers
C_THREADS_BLOCKING_CHANNEL = "blocking"
C_THREADS_BACKGROUND_CHANNEL = "background"

C_PHYSICS_BODY_TYPES = {
    STATIC="static", --do not move
    DYNAMIC="dynamic", --collides with all bodies 
    KINEMATIC="kinematic" --collide with dynamics only
}

C_RENDER_BLEND_MODES = {
    ALPHA="alpha",
    REPLACE="replace",
    SCREEN="screen",
    ADD="add",
    -- SUBTRACT="subtract",
    -- MULTIPLY="multiply",
    -- LIGHTEN="lighten",
    -- DARKEN="darken"
}

-- how many pixels in a meter
C_WORLD_METER_SCALE = 40
-- a scalar for world physics updates
C_WORLD_UPDATE_SCALAR = 1.0
C_WORLD_VEL_ITERATIONS = 12
C_WORLD_POS_ITERATIONS = 12
-- gravity value for the world 
C_WORLD_GRAVITY = {
    X = 0,
    Y = 1000,
}

-- different contact types for the world contact filter function
C_WORLD_CONTACT_TYPES = {
    ALL = 1, -- collides with everything
    DYNAMIC = 2, -- requires can_collide function in the physics object
    NONE = 3 -- collides with no physics objects
}

C_REG_FOLDER = "scripts/definitions/registries/"
C_REG_TYPES = {
    OBJECT = "objects",
    INPUT = "inputs",
    IMAGE = "images",
    SPRITE = "sprites",
    ANIM_FILE = "animfiles",
}

C_LOGGER_LOG_FOLDER = "logs/"
C_LOGGER_LEVELS = {
    CORE = 1,
    NORMAL = 2,
    INFO = 3,
    DEBUG = 4
}

C_INPUT_SCHEME_FOLDER = "input_schemes/"
C_INPUT_IDS = {
    UP="UP",
    DOWN="DOWN",
    LEFT="LEFT",
    RIGHT="RIGHT",
    JUMP="JUMP",
    SPRINT="SPRINT",
    SHOOT="SHOOT",
}

C_PLAYER_HORI_MOVE_SPEED = 4 * C_WORLD_METER_SCALE
-- how strong the initial impulse is in respect to C_PLAYER_HORI_MOVE_SPEED
C_PLAYER_HORI_MOVE_START_SCALAR = 0.5
-- the scalar for when the player moves without holding shift 
C_PLAYER_WALK_SCALAR = 1

-- time the player can jump for (s)
C_PLAYER_MAX_JUMP_TIME = 0.4
-- initial impulse
C_PLAYER_JUMP_STRENGTH = 10 * C_WORLD_METER_SCALE
-- strength of fully held jump ability
C_PLAYER_JUMP_HOLD_STRENGTH = 10 * C_WORLD_METER_SCALE / C_PLAYER_MAX_JUMP_TIME
-- downwards force to apply when jumping
C_PLAYER_COUNTER_JUMP_FORCE = 250

-- strength of forced gravity 
C_PLAYER_DOWN_STRENGTH = 20
