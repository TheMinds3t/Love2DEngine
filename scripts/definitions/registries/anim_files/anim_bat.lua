local mth = require("love.math")
require("scripts.core.constants")

return
{
	animations = 
	{
		fly =
		{
			anim_layer = C_RENDER_LAYERS.INGAME, 
			interpolation = C_RENDER_INTERPOLATE_TYPE.NORMAL,
			frames = {
				{image="ENEMY_BAT",dimensions={x=0,y=0,w=32,h=32}, size={w=32,h=32}, frames=8, x_pivot = 16, y_pivot = 16, transform = mth.newTransform(0,-8,1,1,10,-16,-16), color=C_COLOR_DEFAULT},
				{image="ENEMY_BAT",dimensions={x=32,y=0,w=32,h=32}, size={w=32,h=32}, frames=8, x_pivot = 16, y_pivot = 16, transform = mth.newTransform(0,-8,1,1,20,-16,-16), color=C_COLOR_DEFAULT},
				{image="ENEMY_BAT",dimensions={x=64,y=0,w=32,h=32}, size={w=32,h=32}, frames=8, x_pivot = 16, y_pivot = 16, transform = mth.newTransform(0,-8,1,1,30,-16,-16), color=C_COLOR_DEFAULT},
			},
		},
		attack =
		{
			anim_layer = C_RENDER_LAYERS.INGAME, 
			interpolation = C_RENDER_INTERPOLATE_TYPE.NORMAL,
			frames = {
				{image="ENEMY_BAT",dimensions={x=0,y=32,w=32,h=32}, size={w=32,h=32}, frames=8, x_pivot = 16, y_pivot = 16, transform = mth.newTransform(0,-8,1,1,0,-16,-16), color=C_COLOR_DEFAULT},
				{image="ENEMY_BAT",dimensions={x=32,y=32,w=32,h=32}, size={w=32,h=32}, frames=8, x_pivot = 16, y_pivot = 16, transform = mth.newTransform(0,-9,1,1,0,-16,-16), color=C_COLOR_DEFAULT},
				{image="ENEMY_BAT",dimensions={x=64,y=32,w=32,h=32}, size={w=32,h=32}, frames=8, x_pivot = 16, y_pivot = 16, transform = mth.newTransform(0,-10,1,1,0,-16,-16), color=C_COLOR_DEFAULT},
				{image="ENEMY_BAT",dimensions={x=32,y=32,w=32,h=32}, size={w=32,h=32}, frames=8, x_pivot = 16, y_pivot = 16, transform = mth.newTransform(0,-9,1,1,0,-16,-16), color=C_COLOR_DEFAULT},
				{image="ENEMY_BAT",dimensions={x=0,y=32,w=32,h=32}, size={w=32,h=32}, frames=8, x_pivot = 16, y_pivot = 16, transform = mth.newTransform(0,-8,1,1,0,-16,-16), color=C_COLOR_DEFAULT},
			},
		},
	}
}