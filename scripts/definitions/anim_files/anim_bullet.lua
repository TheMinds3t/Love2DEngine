local mth = require("love.math")
require("scripts.core.constants")

return
{
	animations = 
	{
		bullet =
		{
			anim_layer = C_RENDER_LAYERS.INGAME, 
			frames = {
				{image="BULLET_ATLAS", dimensions={x=0,y=0,w=32,h=32}, frames=8, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="BULLET_ATLAS", dimensions={x=0,y=32,w=32,h=32}, frames=8, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 1, y_scale = 1.1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="BULLET_ATLAS", dimensions={x=32,y=32,w=32,h=32}, frames=8, x_pos = 0, y_pos = 0, x_pivot = 16, y_pivot = 16, x_scale = 0.95, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
			},
		},
		effect =
		{
			anim_layer = C_RENDER_LAYERS.INGAME, 
			no_loop = true,
			frames = {
				{image="BULLET_ATLAS", dimensions={x=32,y=0,w=16,h=16}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 8, y_pivot = 8, x_scale = 1, y_scale = 1, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="BULLET_ATLAS", dimensions={x=48,y=0,w=16,h=16}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 8, y_pivot = 8, x_scale = 1.25, y_scale = 0.8, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="BULLET_ATLAS", dimensions={x=32,y=16,w=16,h=16}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 8, y_pivot = 8, x_scale = 1.5, y_scale = 0.6, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="BULLET_ATLAS", dimensions={x=48,y=16,w=16,h=16}, frames=4, x_pos = 0, y_pos = 0, x_pivot = 8, y_pivot = 8, x_scale = 1.75, y_scale = 0.4, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NORMAL},
				{image="BULLET_ATLAS", dimensions={x=48,y=16,w=16,h=16}, frames=1, x_pos = 0, y_pos = 0, x_pivot = 8, y_pivot = 8, x_scale = 2.0, y_scale = 0.2, rotate = 0, color={r=255,g=255,b=255,a=0}, interp=C_RENDER_INTERPOLATE_TYPE.NONE},
			},
		},
	}
}