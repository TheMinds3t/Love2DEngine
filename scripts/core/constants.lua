C_LOGIC_FRAME_RATE = 60.0

C_GAMENAME = "demonical"

-- serializer keyterms
C_FH_SERIAL_CONNECT = "="
C_FH_SERIAL_TABLE_START = "{"
C_FH_SERIAL_TABLE_END = "}"
C_FH_SERIAL_DELIM = ","

C_RENDER_LAYERS = {
    "background", -- background
    "ingame", -- ingame 
    "hud", -- ingame hud
    "menu", -- menu graphics
    "buffer" -- loading screen
}

C_THREADS_BLOCKING_CHANNEL = "blocking"
C_THREADS_BACKGROUND_CHANNEL = "background"

C_PHYSICS_BODY_TYPES = {
    STATIC="static", --do not move
    DYNAMIC="dynamic", --collides with all bodies 
    KINEMATIC="kinematic" --collide with dynamics only
}

C_WORLD_METER_SCALE = 128
C_WORLD_UPDATE_SCALAR = 2.0
C_WORLD_VEL_ITERATIONS = 8
C_WORLD_POS_ITERATIONS = 3
C_WORLD_GRAVITY = {
    X = 0,
    Y = 1000,
}

C_REG_FOLDER = "scripts/definitions/registries/"
C_REG_TYPES = {
    OBJECT = "objects",
    INPUT = "inputs"
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
}

C_PLAYER_HORI_MOVE_SPEED = 250
C_PLAYER_HORI_MAX_MOVE_SPEED = 500
C_PLAYER_HORI_MOVE_START_SCALAR = 1.0 / 4.0
C_PLAYER_JUMP_STRENGTH = 55
C_PLAYER_JUMP_HOLD_STRENGTH = 13.5