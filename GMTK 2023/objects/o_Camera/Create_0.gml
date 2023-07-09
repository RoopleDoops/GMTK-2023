movement_create();

enum CAMERA_STATE {
	LOCK,
	PAN,
	PLAY
}
camera_state = CAMERA_STATE.LOCK;
xTo = x;
yTo = y;


// CUTSCENE
cutscene_time = 0;
cutscene_time_max = 300;
cutscene_msg1_time = 30;
cutscene_msg2_time = 150;

cam = view_camera[0];
cam_zoom_cutscene = 0.5;
cam_zoom_play = 1;
cam_zoom = cam_zoom_cutscene;
cam_zoom_incr = 1/90;
cam_zoom_lerp = lerp_create(cam_zoom_cutscene, cam_zoom_play, cam_zoom_incr);
camera_set_view_size(cam,GAME_WIDTH*cam_zoom,GAME_HEIGHT*cam_zoom);

cam_x_half = camera_get_view_width(cam)/2;
cam_y_half = camera_get_view_height(cam)/2;

camera_frame_val = 125;
camera_frame_val_centered = 75;

follow = o_Player;
move_accel_base = 0.04;
move_accel_slow = 0.005;
move_accel_fast = 0.08;
move_accel_accel = 0.1; // how fast to move BETWEEN move_accel values
move_accel = move_accel_base;
move_accel_target = move_accel;

camera_setup = false;



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

camera_follow = function(_instance,_force=false){
	if (_force) || (camera_state == CAMERA_STATE.PLAY) {
		if (instance_exists(_instance)) {
			follow = _instance;	
		}
	}
}

check_camera_in_framex = function(_framesize) {
	if (follow.x < 0 + (cam_x_half*cam_zoom))
	|| (follow.x > room_width - (cam_x_half*cam_zoom)) return true;
	else if (x - follow.x > _framesize)
	|| (follow.x - x > _framesize) return false;
	else return true;
}

check_camera_in_framey = function(_framesize) {
	if (follow.y < 0 + (cam_y_half*cam_zoom))
	|| (follow.y > room_height - (cam_y_half*cam_zoom)) return true;
	else if (y - follow.y > _framesize)
	|| (follow.y - y > _framesize) return false;
	else return true;
}

check_camera_in_frame = function(_framesize) {
	return (check_camera_in_framex(_framesize)) && (check_camera_in_framey(_framesize))
}

check_player_on_screen = function() {
	if (instance_exists(o_Player)) {
		if (within_range(o_Player.x,x-cam_x_half,x+cam_x_half))
		&& (within_range(o_Player.y,y+cam_y_half,y-cam_y_half)) return true;
	}
}

camera_zoom_step = function() {
	// CAM ZOOM
	lerp_step(cam_zoom_lerp);
	cam_zoom = cam_zoom_lerp.lerp_value;
	camera_set_view_size(cam,GAME_WIDTH*cam_zoom,GAME_HEIGHT*cam_zoom);
	cam_x_half = camera_get_view_width(cam)/2;
	cam_y_half = camera_get_view_height(cam)/2;	
}

camera_cutscene = function() {
	camera_state = CAMERA_STATE.LOCK;
	camera_follow(o_Knight,true);
}

camera_pan = function(_follow) {
	camera_state = CAMERA_STATE.PAN;
	camera_follow(_follow,true);
	move_accel_target = move_accel_slow;
	move_accel = move_accel_slow;
}

camera_play = function() {
	camera_state = CAMERA_STATE.PLAY;
	camera_follow(o_Player,true);
	move_accel_target = move_accel_base;
	move_accel = move_accel_base;
}

perform_step = function(){
	if (!camera_setup) {
		if (debug_mode) camera_play();
		else camera_cutscene(); 
		camera_snap(); 
		camera_setup = true;
	}
	
	switch (camera_state) {
		case CAMERA_STATE.LOCK:
			if (cutscene_time >= cutscene_time_max) {o_Knight.progress_speech(0); camera_pan(o_Player)};
			else cutscene_time += 1;
			if (cutscene_time == cutscene_msg1_time) o_Knight.progress_speech(1);
			else if (cutscene_time == cutscene_msg2_time) o_Knight.progress_speech(2);
		break;
		case CAMERA_STATE.PAN:
			camera_zoom_step();
			if (check_player_on_screen()) camera_play();	
		break;
		case CAMERA_STATE.PLAY:
			camera_zoom_step();
		break;
	}
	
	if (instance_exists(follow))
	{
		// Must round these or camera will lerp back and forth between one pixel when near target
		xTo = round(follow.x);
		yTo = round(follow.y);
		
		if (camera_state == CAMERA_STATE.PLAY) {
			// Increase move_accel if camera is lagging behind
			if (!check_camera_in_frame(camera_frame_val)) move_accel_target = move_accel_fast;
			if (move_accel_target == move_accel_fast) && (check_camera_in_frame(camera_frame_val_centered)) {
				move_accel_target = move_accel_base;	
			}
			move_accel = lerp(move_accel,move_accel_target,move_accel_accel);
		}
		x_move = lerp(x,xTo,move_accel)-x;
		y_move = lerp(y,yTo,move_accel)-y;	
	}
	
	
	// CAM MOVE
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
	
	x = clamp(x,0+cam_x_half,room_width-cam_x_half);
	y = clamp(y,0,room_height-cam_y_half);
	
	camera_set_view_pos(cam,round(x-cam_x_half),round(y-cam_y_half));
}