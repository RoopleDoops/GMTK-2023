function scale_create(){
#region
	var _struct = 
	{
		scale_scalex : 1,
		scale_scaley : 1,
		scale_scalex_start : 1,
		scale_scaley_start : 1,
		scale_scalex_goal : 1,
		scale_scaley_goal : 1,
		scale_time : 0
	}
	return _struct;
#endregion
}

function scale_step(_struct,_duration){
#region
	with (_struct)
	{
		if (scale_time < _duration)
		{
			scale_scalex = ease_out_elastic(scale_time,scale_scalex_start,scale_scalex_goal-scale_scalex_start,_duration);
			scale_scaley = ease_out_elastic(scale_time,scale_scaley_start,scale_scaley_goal-scale_scaley_start,_duration)
			scale_time += 1;
		}
	}
#endregion
}

function scale_draw(_struct,_x,_y){
#region
	draw_sprite_ext(sprite_index,image_index,_x,_y,image_xscale*_struct.scale_scalex,image_yscale*_struct.scale_scaley,
	image_angle,image_blend,image_alpha);
#endregion
}

function scale_draw_ext(_struct,_sprite_index,_image_index,_x,_y, _image_xscale, _image_yscale,
_image_angle,_image_blend,_image_alpha){
#region
	draw_sprite_ext(_sprite_index,_image_index,_x,_y,_image_xscale*_struct.scale_scalex,_image_yscale*_struct.scale_scaley,
	_image_angle,_image_blend,_image_alpha);
#endregion
}

function scale_apply(_struct,_scale_x,_scale_y){
#region
	with (_struct)
	{
		scale_scalex = _scale_x;
		scale_scaley = _scale_y;
	}
#endregion
}

///@func	squash_scale()
///@desc	Generic scale used for shooting and other functions
///@param	_struct
///@param	_xscale
///@param	_yscale
function squash_scale(_struct,_xscale = 1.3,_yscale = 0.7){
	with (_struct)
	{
		scale_apply(_struct,_xscale,_yscale);
		scale_time = 0;
		scale_scalex_start = scale_scalex;
		scale_scaley_start = scale_scaley;
	}
}

///@func	squash_scale_rand()
///@desc	Applies intensity with random sign +/- to x/y respectably.
///@param	_struct
///@param	_intensity
function squash_scale_rand(_struct,_intensity = 0.1){
	with (_struct)
	{
		var _sign = choose(-1,1);
		scale_apply(_struct,1+(_sign*_intensity),1-(_sign*_intensity));
		scale_time = 0;
		scale_scalex_start = scale_scalex;
		scale_scaley_start = scale_scaley;
	}
}
