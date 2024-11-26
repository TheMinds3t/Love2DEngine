-- how many ticks should elapse in 1 second
C_TICKS_PER_SECOND = 60.0
C_MAX_DELTA_ALLOWED = 1 / C_TICKS_PER_SECOND * 5

C_GAMENAME = "demonical"
C_WINDOW_DIMENSIONS = {
    WIDTH=800,
    HEIGHT=600
}
C_SYSTEM_OS_TYPES = {
    WINDOWS = "Windows",
    LINUX = "Linux",
    ANDROID = "Android",
    iOS = "iOS",
    MAC = "OS X"
}

-- serializer keyterms
C_FH_SERIAL_CONNECT = "="
C_FH_SERIAL_TABLE_START = "{"
C_FH_SERIAL_TABLE_END = "}"
C_FH_SERIAL_DELIM = ","

C_FONT_SIZE_REGULAR = 21

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
}

-- scale factor for all rendered sprites
C_RENDER_ROOT_SPRITE_SCALE = 2
C_RENDER_ROOT_UI_SCALE = 2
C_RENDER_TEXTURE_WRAPMODE = "repeat"

-- health state rendering
C_RENDER_MAX_HURT_TIME = 0.15
C_RENDER_HEALTHBAR_BACK = {r=10,g=10,b=10,a=200}
C_RENDER_HEALTHBAR_FRONT = {r=200,g=50,b=100,a=200}
C_RENDER_HEALTHBAR_DIMS = {WIDTH=75,HEIGHT=12}

-- default color when color is unspecified
C_COLOR_WHITE = {r=255,g=255,b=255,a=255}
C_COLOR_EMPTY = {r=0,g=0,b=0,a=0}

C_UI_BOX_BACKGROUND_COLOR = {r=0,g=0,b=0,a=200}
C_UI_BOX_OUTLINE_COLOR = {r=255,g=50,b=200,a=255}
C_UI_MIN_BOX_EDGE_SIZE = 1
C_UI_MAX_BOX_EDGE_SIZE = 6
C_UI_BOX_EDGES = 1
C_UI_BOX_ROUND_FACTOR = 200

C_UI_DIALOGUE_DIMS = {WIDTH=250,HEIGHT=50}
C_UI_DIALOGUE_TEXT_WIDTH = 240
C_UI_DIALOGUE_UPDATE_FREQUENCY = 3
C_UI_DIALOGUE_HOLD_SCALAR = 0.05
C_UI_DIALOGUE_MIN_HOLD = 2
C_UI_DIALOGUE_MAX_HOLD = 5

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
C_WORLD_VEL_ITERATIONS = 32
C_WORLD_POS_ITERATIONS = 32
-- gravity value for the world 
C_WORLD_GRAVITY = {
    X = 0,
    Y = 25,
}

C_ADDITIONAL_GRAV_SCALAR = 0.25

-- different contact types for the world contact filter function
C_WORLD_CONTACT_TYPES = {
    ALL = 1, -- collides with everything
    DYNAMIC = 2, -- requires can_collide function in the physics object
    NONE = 3, -- collides with no physics objects
    NOT_SAME = 4, -- collides with objects with a different ID
    NOT_IN_LIST = 5, -- collides with objects not in the required no_collide_list
    ONLY_IN_LIST = 6, -- collides with objects in the required only_collide_list
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
    ERROR = 0,
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

C_PLAYER_HORI_MOVE_SPEED = 8 * C_WORLD_METER_SCALE
-- how strong the initial impulse is in respect to C_PLAYER_HORI_MOVE_SPEED
C_PLAYER_HORI_MOVE_START_SCALAR = 0.5
-- the scalar for when the player moves without holding shift 
C_PLAYER_WALK_SCALAR = 0.66
-- time the player can jump for (s)
C_PLAYER_MAX_JUMP_TIME = 0.5
-- initial impulse
C_PLAYER_JUMP_STRENGTH = 10 * C_WORLD_METER_SCALE
-- strength of fully held jump ability
C_PLAYER_JUMP_HOLD_STRENGTH = 25 * C_WORLD_METER_SCALE
-- downwards force to apply when jumping
C_PLAYER_COUNTER_JUMP_FORCE = 250
-- strength of forced gravity 
C_PLAYER_DOWN_STRENGTH = 10 * C_WORLD_METER_SCALE
-- variance from 0 that is allowed for the x-collision vector
C_PLAYER_GROUND_CONNECT_THRES = 0.5
-- what % of C_WORLD_METER_SCALE should knockback be when firing
C_PLAYER_KNOCKBACK_STRENGTH = 0.3

C_CAMERA_MOVEMENT_TYPE = {
    NORMAL=1, -- follows player on delay
    FIXED=2, -- no movement
    NORMAL_CURSOR=3, -- follows player and cursor position
}

C_CAMERA_BASE_SPEED = 0
C_CAMERA_MAX_SPEED = 4
C_CAMERA_TARGET_FORGIVENESS = 0
C_CAMERA_MOUSE_CAPTURE_SCALAR = 0.15