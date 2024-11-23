local mth = require("love.math")
require("scripts.core.constants")

return
{
	animations = 
	{
		buffer =
		{
			anim_layer = C_RENDER_LAYERS.BUFFER, 
			frames = {
				{image="UI_BUFFER_WHEEL",dimensions={x=0,y=0,w=64,h=64}, frames=10, x_pos = 0, y_pos = 0, x_pivot = 32, y_pivot = 32, x_scale = 0.5, y_scale = 0.5, rotate = 0, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NONE},
				{image="UI_BUFFER_WHEEL",dimensions={x=0,y=0,w=64,h=64}, frames=10, x_pos = 0, y_pos = 0, x_pivot = 32, y_pivot = 32, x_scale = 0.5, y_scale = 0.5, rotate = 45, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NONE},
				{image="UI_BUFFER_WHEEL",dimensions={x=0,y=0,w=64,h=64}, frames=10, x_pos = 0, y_pos = 0, x_pivot = 32, y_pivot = 32, x_scale = 0.5, y_scale = 0.5, rotate = 90, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NONE},
				{image="UI_BUFFER_WHEEL",dimensions={x=0,y=0,w=64,h=64}, frames=10, x_pos = 0, y_pos = 0, x_pivot = 32, y_pivot = 32, x_scale = 0.5, y_scale = 0.5, rotate = 135, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NONE},
				{image="UI_BUFFER_WHEEL",dimensions={x=0,y=0,w=64,h=64}, frames=10, x_pos = 0, y_pos = 0, x_pivot = 32, y_pivot = 32, x_scale = 0.5, y_scale = 0.5, rotate = 180, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NONE},
				{image="UI_BUFFER_WHEEL",dimensions={x=0,y=0,w=64,h=64}, frames=10, x_pos = 0, y_pos = 0, x_pivot = 32, y_pivot = 32, x_scale = 0.5, y_scale = 0.5, rotate = 225, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NONE},
				{image="UI_BUFFER_WHEEL",dimensions={x=0,y=0,w=64,h=64}, frames=10, x_pos = 0, y_pos = 0, x_pivot = 32, y_pivot = 32, x_scale = 0.5, y_scale = 0.5, rotate = 270, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NONE},
				{image="UI_BUFFER_WHEEL",dimensions={x=0,y=0,w=64,h=64}, frames=10, x_pos = 0, y_pos = 0, x_pivot = 32, y_pivot = 32, x_scale = 0.5, y_scale = 0.5, rotate = 315, color=C_COLOR_WHITE, interp=C_RENDER_INTERPOLATE_TYPE.NONE},
			},
		},

	}
}