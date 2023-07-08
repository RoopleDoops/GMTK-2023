#macro SCREEN_SHAKE o_Camera.camera_screen_shake(15,1)

movement_create();

xTo = x;
yTo = y;

cam = view_camera[0];
camera_set_view_size(cam,GAME_WIDTH,GAME_HEIGHT);
cam_width = view_get_wport(cam);
cam_height = view_get_hport(cam);

cam_x_half = camera_get_view_width(cam)/2;
cam_y_half = camera_get_view_height(cam)/2;

cam_x_buffer = 32;
cam_y_buffer = 32;

camera_frame_val = 125;
camera_frame_val_centered = 75;

shake_x = 0;
shake_y = 0;
shake_power = 0;
shake_time = 0;
shake_freq = 0;
shake_freq_max = 2;

follow = o_Player;
move_accel_base = 0.04;
move_accel_fast = 0.08;
move_accel_accel = 0.1; // how fast to move BETWEEN move_accel values
move_accel = move_accel_base;
move_accel_target = move_accel;


camera_snap = function(){
	if (instance_exists(follow))
	{
		var _px = follow.x;
		var _py = follow.y;
		x = _px;
		y = _py;
		xTo = x;
		yTo = y;
	}
}

camera_follow = function(_instance){
	if (instance_exists(_instance)) {
		follow = _instance;	
	}
}

camera_screen_shake = function(_dur,_power){
	shake_time = _dur;
	shake_power = _power;
}

check_camera_in_framex = function(_framesize) {
	if (follow.x < 0 + cam_x_half)
	|| (follow.x > room_width - cam_x_half) return true;
	else if (x - follow.x > _framesize)
	|| (follow.x - x > _framesize) return false;
	else return true;
}

check_camera_in_framey = function(_framesize) {
	if (follow.y < 0 + cam_y_half)
	|| (follow.y > room_height - cam_y_half) return true;
	else if (y - follow.y > _framesize)
	|| (follow.y - y > _framesize) return false;
	else return true;
}

check_camera_in_frame = function(_framesize) {
	return (check_camera_in_framex(_framesize)) && (check_camera_in_framey(_framesize))
}

perform_step = function(){
	if (shake_time > 0) 
	{
		shake_time -= 1;
		if (shake_freq > 0) shake_freq -= 1;
		else
		{
			shake_freq = shake_freq_max;
			if (shake_x == 0) shake_x = choose(-shake_power,shake_power);
			else shake_x = -shake_x;
			if (shake_y == 0) shake_y = choose(-shake_power,shake_power);
			else shake_y = -shake_y;
		}
	}
	if (shake_time == 0) {shake_x = 0; shake_y = 0; shake_power = 0;}
	
	if (instance_exists(follow))
	{
		// Must round these or camera will lerp back and forth between one pixel when near target
		xTo = round(follow.x);
		yTo = round(follow.y);
		
		// Increase move_accel if camera is lagging behind
		if (!check_camera_in_frame(camera_frame_val)) move_accel_target = move_accel_fast;
		if (move_accel_target == move_accel_fast) && (check_camera_in_frame(camera_frame_val_centered)) {
			move_accel_target = move_accel_base;	
		}
		
		move_accel = lerp(move_accel,move_accel_target,move_accel_accel);
	
		x_move = lerp(x,xTo,move_accel)-x;
		y_move = lerp(y,yTo,move_accel)-y;
		//x_move = -(x - xTo) * move_accel;
		//y_move = -(y - yTo) * move_accel;
	}
	
	x_move = clamp(x_move+x_knock,-TERM_VELOC,TERM_VELOC);
	x_move_bank += x_move;
	var _x_move = sign(x_move_bank) * abs(floor(x_move_bank));
	x_move_bank -= _x_move;
	x_knock = 0;
	
	y_move = clamp(y_move+y_knock,-TERM_VELOC,TERM_VELOC);
	y_move_bank += y_move;
	var _y_move = sign(y_move_bank) * abs(floor(y_move_bank));
	y_move_bank -= _y_move;
	y_knock = 0;
	
	x = x + _x_move;
	y = y + _y_move;
	
	x = clamp(x,0+cam_x_half,room_width-cam_x_half) + shake_x;
	y = clamp(y,0,room_height-cam_y_half)  + shake_y;
	
	camera_set_view_pos(cam,round(x-cam_x_half),round(y-cam_y_half));
}