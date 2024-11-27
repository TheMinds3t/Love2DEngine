local mth = require("love.math")
require("scripts.core.constants")

return
{
	animations = 
	{
		fly =
		{
			anim_layer = C_RENDER_LAYERS.INGAME, 
			frames = {
				{image="ENEMY_BARTOX",dimensions={x=0,y=0,w=96,h=96}, frames=8, x_pos = 0, y_pos = 0, x_pivot = 48, y_pivot = 48, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_BARTOX",dimensions={x=96,y=0,w=96,h=96}, frames=8, x_pos = 0, y_pos = 0, x_pivot = 48, y_pivot = 48, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_BARTOX",dimensions={x=192,y=0,w=96,h=96}, frames=8, x_pos = 0, y_pos = 0, x_pivot = 48, y_pivot = 48, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_BARTOX",dimensions={x=0,y=96,w=96,h=96}, frames=8, x_pos = 0, y_pos = 0, x_pivot = 48, y_pivot = 48, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_BARTOX",dimensions={x=96,y=96,w=96,h=96}, frames=8, x_pos = 0, y_pos = 0, x_pivot = 48, y_pivot = 48, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_BARTOX",dimensions={x=192,y=96,w=96,h=96}, frames=8, x_pos = 0, y_pos = 0, x_pivot = 48, y_pivot = 48, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
			},
			events = {
				[25] = "big_flap",
			}
		},
		charge =
		{
			anim_layer = C_RENDER_LAYERS.INGAME, 
			frames = {
				{image="ENEMY_BARTOX",dimensions={x=0,y=192,w=96,h=96}, frames=5, x_pos = 0, y_pos = 0, x_pivot = 48, y_pivot = 48, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_BARTOX",dimensions={x=96,y=192,w=96,h=96}, frames=5, x_pos = 0, y_pos = 0, x_pivot = 48, y_pivot = 48, x_scale = 1, y_scale = 1.1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_BARTOX",dimensions={x=192,y=192,w=96,h=96}, frames=5, x_pos = 0, y_pos = 0, x_pivot = 48, y_pivot = 48, x_scale = 1.1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_BARTOX",dimensions={x=0,y=192,w=96,h=96}, frames=5, x_pos = 0, y_pos = 0, x_pivot = 48, y_pivot = 48, x_scale = 1, y_scale = 1.1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_BARTOX",dimensions={x=96,y=192,w=96,h=96}, frames=5, x_pos = 0, y_pos = 0, x_pivot = 48, y_pivot = 48, x_scale = 1.1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="ENEMY_BARTOX",dimensions={x=192,y=192,w=96,h=96}, frames=5, x_pos = 0, y_pos = 0, x_pivot = 48, y_pivot = 48, x_scale = 1, y_scale = 1.1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
			},
		},
	}
}