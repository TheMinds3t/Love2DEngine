local mth = require("love.math")
require("scripts.core.constants")

return
{
	animations = 
	{
		idle =
		{
			anim_layer = C_RENDER_LAYERS.INGAME, 
			frames = {
				{image="ENEMY_SPIDER",dimensions={x=0,y=0,w=32,h=32}, frames=10, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_SPIDER",dimensions={x=0,y=32,w=32,h=32}, frames=10, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1, y_scale = 1.1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
			},
		},
		attack =
		{
			anim_layer = C_RENDER_LAYERS.INGAME, 
			no_loop = true,
			frames = {
				{image="ENEMY_SPIDER",dimensions={x=32,y=0,w=32,h=32}, size={w=32,h=32}, frames=6, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_SPIDER",dimensions={x=32,y=32,w=32,h=32}, size={w=32,h=32}, frames=7, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 0.9, y_scale = 1.1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_SPIDER",dimensions={x=32,y=0,w=32,h=32}, size={w=32,h=32}, frames=8, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 0.8, y_scale = 1.2, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_SPIDER",dimensions={x=32,y=32,w=32,h=32}, size={w=32,h=32}, frames=12, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 0.65, y_scale = 1.5, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_SPIDER",dimensions={x=32,y=0,w=32,h=32}, size={w=32,h=32}, frames=8, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 0.8, y_scale = 1.2, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_SPIDER",dimensions={x=32,y=32,w=32,h=32}, size={w=32,h=32}, frames=6, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 0.9, y_scale = 1.1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_SPIDER",dimensions={x=32,y=0,w=32,h=32}, size={w=32,h=32}, frames=6, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_SPIDER",dimensions={x=32,y=32,w=32,h=32}, size={w=32,h=32}, frames=6, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_SPIDER",dimensions={x=32,y=0,w=32,h=32}, size={w=32,h=32}, frames=6, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_SPIDER",dimensions={x=32,y=32,w=32,h=32}, size={w=32,h=32}, frames=6, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_SPIDER",dimensions={x=32,y=0,w=32,h=32}, size={w=32,h=32}, frames=6, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_SPIDER",dimensions={x=32,y=32,w=32,h=32}, size={w=32,h=32}, frames=6, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_SPIDER",dimensions={x=32,y=0,w=32,h=32}, size={w=32,h=32}, frames=6, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_SPIDER",dimensions={x=32,y=32,w=32,h=32}, size={w=32,h=32}, frames=6, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
			},
			events = {
				[27] = "fire",
				[34] = "fire",
				[41] = "fire",
				[48] = "fire",
				[55] = "fire",
			}
		},
	}
}