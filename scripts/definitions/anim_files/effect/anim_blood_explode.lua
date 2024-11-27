local mth = require("love.math")
require("scripts.core.constants")

return
{
	animations = 
	{
		explode_large =
		{
			anim_layer = C_RENDER_LAYERS.INGAME, 
			no_loop = true,
			frames = {
				{image="FX_BLOOD_EXPLODE", dimensions={x=0,y=0,w=64,h=64}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 32, y_pivot = 32, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=64,y=0,w=64,h=64}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 32, y_pivot = 32, x_scale = 1.1, y_scale = 1.1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=128,y=0,w=64,h=64}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 32, y_pivot = 32, x_scale = 1.2, y_scale = 1.2, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=192,y=0,w=64,h=64}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 32, y_pivot = 32, x_scale = 1.3, y_scale = 1.3, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=0,y=64,w=64,h=64}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 32, y_pivot = 32, x_scale = 1.4, y_scale = 1.4, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=64,y=64,w=64,h=64}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 32, y_pivot = 32, x_scale = 1.5, y_scale = 1.5, rotate = 0, color={a=200}, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=128,y=64,w=64,h=64}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 32, y_pivot = 32, x_scale = 1.6, y_scale = 1.6, rotate = 0, color={a=200}, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=192,y=64,w=64,h=64}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 32, y_pivot = 32, x_scale = 1.7, y_scale = 1.7, rotate = 0, color={a=200}, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=192,y=64,w=64,h=64}, frames=1, x_pos = 0, y_pos = 0, x_pivot = 32, y_pivot = 32, x_scale = 1.8, y_scale = 1.8, rotate = 0, color={a=0}, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
			},
		},
		explode =
		{
			anim_layer = C_RENDER_LAYERS.INGAME, 
			no_loop = true,
			frames = {
				{image="FX_BLOOD_EXPLODE", dimensions={x=0,y=128,w=32,h=32}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=32,y=128,w=32,h=32}, frames=5, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1.1, y_scale = 1.1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=64,y=128,w=32,h=32}, frames=5, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1.2, y_scale = 1.2, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=96,y=128,w=32,h=32}, frames=5, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1.3, y_scale = 1.3, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=0,y=160,w=32,h=32}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1.4, y_scale = 1.4, rotate = 0, color={a=200}, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=32,y=160,w=32,h=32}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1.5, y_scale = 1.5, rotate = 0, color={a=100}, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=64,y=160,w=32,h=32}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1.6, y_scale = 1.6, rotate = 0, color={a=75}, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=96,y=160,w=32,h=32}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1.7, y_scale = 1.7, rotate = 0, color={a=33}, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=96,y=160,w=32,h=32}, frames=1, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1.8, y_scale = 1.8, rotate = 0, color={a=0}, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
			},
		},
		explode_small =
		{
			anim_layer = C_RENDER_LAYERS.INGAME, 
			no_loop = true,
			frames = {
				{image="FX_BLOOD_EXPLODE", dimensions={x=128,y=128,w=16,h=16}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 8, y_pivot = 8, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=144,y=128,w=16,h=16}, frames=5, x_pos = 0, y_pos = 0, x_pivot = 8, y_pivot = 8, x_scale = 1.1, y_scale = 1.1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=160,y=128,w=16,h=16}, frames=5, x_pos = 0, y_pos = 0, x_pivot = 8, y_pivot = 8, x_scale = 1.2, y_scale = 1.2, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=176,y=128,w=16,h=16}, frames=5, x_pos = 0, y_pos = 0, x_pivot = 8, y_pivot = 8, x_scale = 1.3, y_scale = 1.3, rotate = 0, color={a=200}, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=128,y=144,w=16,h=16}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 8, y_pivot = 8, x_scale = 1.4, y_scale = 1.4, rotate = 0, color={a=125}, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=144,y=144,w=16,h=16}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 8, y_pivot = 8, x_scale = 1.5, y_scale = 1.5, rotate = 0, color={a=60}, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=144,y=144,w=16,h=16}, frames=1, x_pos = 0, y_pos = 0, x_pivot = 8, y_pivot = 8, x_scale = 1.6, y_scale = 1.6, rotate = 0, color={a=0}, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
			},
		},
		explode_tiny =
		{
			anim_layer = C_RENDER_LAYERS.INGAME, 
			no_loop = true,
			frames = {
				{image="FX_BLOOD_EXPLODE", dimensions={x=192,y=128,w=8,h=8}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 4, y_pivot = 4, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=200,y=128,w=8,h=8}, frames=5, x_pos = 0, y_pos = 0, x_pivot = 4, y_pivot = 4, x_scale = 1.1, y_scale = 1.1, rotate = 0, color={a=200}, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=208,y=128,w=8,h=8}, frames=5, x_pos = 0, y_pos = 0, x_pivot = 4, y_pivot = 4, x_scale = 1.2, y_scale = 1.2, rotate = 0, color={a=150}, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=216,y=128,w=8,h=8}, frames=5, x_pos = 0, y_pos = 0, x_pivot = 4, y_pivot = 4, x_scale = 1.3, y_scale = 1.3, rotate = 0, color={a=125}, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="FX_BLOOD_EXPLODE", dimensions={x=216,y=128,w=8,h=8}, frames=1, x_pos = 0, y_pos = 0, x_pivot = 4, y_pivot = 4, x_scale = 1.4, y_scale = 1.4, rotate = 0, color={a=0}, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
			},
		},
	}
}