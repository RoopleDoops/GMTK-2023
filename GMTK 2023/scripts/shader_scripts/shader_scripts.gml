function shader_create_color_flash(){
	shader_uniColor = shader_get_uniform(sh_ColorFlash, "u_color");
	shader_color = [1.0, 1.0, 1.0, 1.0];
	shader_uniStrength = shader_get_uniform(sh_ColorFlash, "u_strength");
	shader_strength = 1;
	shader_uniImageAlpha = shader_get_uniform(sh_ColorFlash, "u_image_alpha");
	shader_image_alpha = 1;
	shader_time = 0;
	shader_time_max = 2;
	shader_new_set = false;
	/* shader_new_set is a flag to say a shader has just been called. It is automatically disabled in the
	draw event if a shader is called. Or it will be disabled after the first attempted shader_timer call.
	*/
}

function shader_timer(){
	// Let shader draw once before starting timer
	if (shader_new_set) shader_new_set = false;
	// Otherwise run timer normally
	else
	{
		if (shader_time > 0) shader_time -=1;
	}
}

function shader_draw_color_flash(){
	// Disable new_set when shader is drawn
	shader_new_set = false;
	shader_set(sh_ColorFlash);
	shader_set_uniform_f_array(shader_uniColor,shader_color);
	shader_set_uniform_f(shader_uniStrength,shader_strength);
	shader_set_uniform_f(shader_uniImageAlpha,shader_image_alpha);
}

function shader_color_convert(_color){
	var _red = color_get_red(_color);
	var _green = color_get_green(_color);
	var _blue = color_get_blue(_color);
	_red = round_decimal(_red/255,1);
	_green = round_decimal(_green/255,1);
	_blue = round_decimal(_blue/255,1);
	_converted_color = [_red, _green, _blue, 1.0];
	return _converted_color;
}