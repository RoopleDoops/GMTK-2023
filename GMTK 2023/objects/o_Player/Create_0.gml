movement_create();
//////////////////////////////////
//////////////////////////////////
// PLAYER MOVEMENT NEEDS LERPING 
///////////////////////////////
////////////////////////////////

// MOVEMENT
move_speed = 5;
move_accel = 0.05;
move_gravity = 0.2;
move_gravity_total = 0;
move_gravity_max_up = 0.3;
move_gravity_max_down = 0.4;
jump_power = -7;
jump_max = 1;
jump_left = jump_max;
swing_power = 12;
my_swing = noone;
swing_struct = sine_wave_create(90,60); // set wave to +/-90(deg). Full cycle takes 90 frames
jump_cd_max = 0; // how long after swing before player can input a jump
jump_cd = 0;
release_cd_max = 10; // how long after grabbing a swing before you can let go.
release_cd = release_cd_max;
swing_forgiveness = 0.4;//prevents player from launching downwards if they barely miss the top of the swing
swing_f_back = .1; //how far back to go from f_min after missing a swing.
swing_f_min1 = pi/2;
swing_f_max1 = pi/2 + swing_forgiveness;
swing_f_min2 = 3*pi/2;
swing_f_max2 = 3*pi/2 + swing_forgiveness;
swing_control_cd_max = 15; // how long after swing before player can move horizontally
swing_control_cd = swing_control_cd_max;
//
// DRAWING
scale_struct = scale_create();
debug_draw = false;
face_dir = 1;
dir_change_cd_max = 10;
dir_change_cd = 0;
draw_x = x;
draw_y = y;
draw_scalex = 1;
draw_angle = 0;
draw_angle_target = 0;
draw_swing_snap_lerp_base = 0;
draw_swing_snap_lerp = draw_swing_snap_lerp_base;
draw_swing_snap_lerp_incr = 0.05;
draw_swing_snap_time_max = 0;
draw_swing_snap_time = draw_swing_snap_time_max;
head_y_difference = floor((bbox_top-bbox_bottom)/2); // difference from base of sprite to head rotation point.
draw_coord_update = function(){#region
	switch(move_state) {
		case PLAYER_MOVE_STATE.SWING:
			// delay x/y snap to let player lerp to swing
			if (draw_swing_snap_time > 0) draw_swing_snap_time -=1; 
			else {
				// gradually increase lerp to 1
				if (draw_swing_snap_lerp < 1) {
					draw_swing_snap_lerp += draw_swing_snap_lerp_incr;
					if (draw_swing_snap_lerp > 1) draw_swing_snap_lerp = 1;
				}
			}
			draw_x = lerp(draw_x,x,draw_swing_snap_lerp);
			draw_y = lerp(draw_y,y,draw_swing_snap_lerp);
			var _prog = swing_struct.progress;
			if (within_range(_prog,0,swing_f_max1,false)) face_dir = 1;
			else if (within_range(_prog,swing_f_max1,swing_f_max2,true)) face_dir = -1;
			else face_dir = 1;
		break;
		default:
			draw_x = x; draw_y = y;
			if (move_hori != 0) face_dir = move_hori;
		break;
	}
	if (face_dir != sign(draw_scalex)) {
		if (dir_change_cd <= 0) {squash_scale(scale_struct,1.2,0.8); dir_change_cd = dir_change_cd_max;} 
		draw_scalex = face_dir;
	}
	if (dir_change_cd > 0) dir_change_cd -=1;
#endregion
}
draw_hair_length = sprite_get_height(s_PlayerHair);
draw_hair = function() {#region
	if (move_state == PLAYER_MOVE_STATE.SWING) {
		var _length = point_distance(my_swing.x,my_swing.y,draw_x,draw_y) + head_y_difference;
		var _angle = angle_normalize(point_direction(my_swing.x,my_swing.y,draw_x,draw_y) + 90);
		var _yscale = _length/draw_hair_length;
		draw_sprite_ext(s_PlayerHair,0,my_swing.x,my_swing.y,1,_yscale,_angle,image_blend,image_alpha);
		draw_sprite(s_Swing,0,my_swing.x,my_swing.y);
	}
#endregion
}
//
// STATE MACHINE
enum PLAYER_MOVE_STATE {
	GROUND,
	AIR,
	SWING,
	WIN
}
move_state = PLAYER_MOVE_STATE.AIR;
change_state = function(_state){#region
	switch(_state){
		case PLAYER_MOVE_STATE.GROUND:
			my_swing = noone;
			draw_angle_target = 0;
			draw_angle = draw_angle_target;
			squash_scale(scale_struct,1.2,0.8);
			swing_control_cd = 0;
			jump_cd = 0;
			move_gravity_total = 0;
			jump_left = jump_max;
			movement_stop(AXIS.Y);
			// CAMERA UPDATE
			var _id = id;
			o_Camera.camera_follow(_id);
		break;
		case PLAYER_MOVE_STATE.AIR:
			if (draw_angle >= 180) draw_angle -= 360; //prevents a 359 angle from rotating the long ways around.
			draw_angle_target = 0;
			my_swing = noone;
			// CAMERA UPDATE
			var _id = id;
			o_Camera.camera_follow(_id);
		break;
		case PLAYER_MOVE_STATE.SWING:
			squash_scale(scale_struct,1.2,0.8);
			swing_control_cd = 0;
			release_cd = release_cd_max;
			draw_swing_snap_time = draw_swing_snap_time_max;
			draw_swing_snap_lerp = draw_swing_snap_lerp_base;
			move_gravity_total = 0;
			jump_left = jump_max;
			movement_stop(AXIS.Y);
			movement_stop(AXIS.X);
			// SWING SNAP
			with (my_swing) {
				var _swingx = x;
				var _swingy = y;
				var _swingr = radius;
				var _swingrcol = col_radius;
			}
			// CAMERA UPDATE
			o_Camera.camera_follow(my_swing);
			// NEW POS GET
			// MUST USE COL radius for this or else the player will snap to the wrong place
			// when collision picks it up but it's outside the actual rotation radius
			x = clamp(x,_swingx-_swingrcol,_swingx+_swingrcol); // clamp position to within half circle
			if (x > _swingx) var _dir = 360 - darccos((x-_swingx)/_swingrcol);
			else var _dir = 180 + darccos((_swingx-x)/_swingrcol);
			x = floor(_swingx + lengthdir_x(_swingr,_dir));
			y = floor(_swingy + lengthdir_y(_swingr,_dir) - head_y_difference);
			
			if (x >= _swingx) var _wavedir = -1; // swing left towards center
			else var _wavedir = 1; // swing right towards center
			var _output = _dir - 270;
			var _prog = arcsin(_output/swing_struct.amplitude)*_wavedir;
			sine_wave_set(swing_struct,_prog,_wavedir);
		break;
		case PLAYER_MOVE_STATE.WIN:
			movement_stop(AXIS.X);
			movement_stop(AXIS.Y);
			my_swing = noone;
			draw_angle_target = 0;
			draw_angle = draw_angle_target;
			o_Knight.progress_speech(3);
			squash_scale(scale_struct,1.2,0.8);
		break;
	}
	move_state = _state;
#endregion
}
win_time = 0;
win_time_max = 120;
//

// INPUT
key_left = 0;
key_right = 0;
key_up = 0;
key_down = 0;
key_action = 0;
move_hori = 0;
move_vert = 0;
player_input = function() {#region
	key_left = o_InputManager.get_input_press(INPUT.LEFT);
	key_right = o_InputManager.get_input_press(INPUT.RIGHT);
	key_up = o_InputManager.get_input_press(INPUT.UP);
	key_down = o_InputManager.get_input_press(INPUT.DOWN);
	key_action = o_InputManager.get_input_pressed(INPUT.ACTION);
#endregion
}
//

jump_check = function() {#region
	if (key_action) && (jump_cd <= 0) {
		var _swing = false;
		if (move_state == PLAYER_MOVE_STATE.AIR) _swing = swing_check();
		if (!_swing) perform_jump();
	}
#endregion
}

perform_jump = function() {#region
	if (jump_left > 0) {
		jump_left -= 1;
		y_move = jump_power;	
		squash_scale(scale_struct,1.2,0.8);
		change_state(PLAYER_MOVE_STATE.AIR);
	}
#endregion
}

swing_check = function() {#region
	var _col = false;
	var _num = instance_number(o_Swing);
	for (var _i = 0; _i < _num; _i++) {
		var _swing = instance_find(o_Swing,_i);
		_col =_swing.check_swing(bbox_left,bbox_right,bbox_top,bbox_bottom,_swing.col_extra); 
		if (_col) break;
	}
	if (_col) {
		my_swing = _swing;
		change_state(PLAYER_MOVE_STATE.SWING);
		return true;
	}
#endregion
}

swing_snap = function() {#region // Snaps to swing arc
	// SWING SNAP
	with (my_swing) {
		var _swingx = x;
		var _swingy = y;
		var _swingr = radius;
	}
	// check max for y to make sure player doesn't to point above swing when using col_extra leniency
	var _dir = 270 + swing_struct.output;
	x = floor(_swingx + lengthdir_x(_swingr,_dir) - lengthdir_x(head_y_difference,_dir));
	y = floor(_swingy + lengthdir_y(_swingr,_dir) - lengthdir_y(head_y_difference,_dir));
#endregion
}

get_swing_angle = function() {
	draw_angle_target = angle_normalize(point_direction(x,y,my_swing.x,my_swing.y) - 90);
	draw_angle = draw_angle_target;
}


perform_swing = function() {#region
	swing_snap();
	get_swing_angle(); //updates draw angle of player
	with (my_swing) {
		var _swingx = x;
		var _swingy = y;
		var _swingr = radius;
	}
	
	if (key_action) && (release_cd <=0) {
		// Leniency to prevent player from launching downwards if they barely miss the top of the swing
		var _adj = false;
		if (within_range(swing_struct.progress,swing_f_min1,swing_f_max1)) {
			sine_wave_set(swing_struct,swing_f_min1-swing_f_back);
			_adj = true;
		}
		else if (within_range(swing_struct.progress,swing_f_min2,swing_f_max2)) {
			sine_wave_set(swing_struct,swing_f_min2-swing_f_back);
			_adj = true;
		}
		if (_adj) sine_wave_step(swing_struct);
		
		var _dir = 270 + swing_struct.output;
		var _sx1 = (_swingx + lengthdir_x(_swingr,_dir));
		var _sy1 = (_swingy + lengthdir_y(_swingr,_dir));
		sine_wave_step(swing_struct);
		var _dir = 270 + swing_struct.output;
		var _sx2 = (_swingx + lengthdir_x(_swingr,_dir));
		var _sy2 = (_swingy + lengthdir_y(_swingr,_dir));
		var _launchdir = point_direction(_sx1,_sy1,_sx2,_sy2);
		x_move = lengthdir_x(swing_power,_launchdir);
		y_move = lengthdir_y(swing_power,_launchdir);
		swing_control_cd = swing_control_cd_max;
		jump_cd = jump_cd_max;
		change_state(PLAYER_MOVE_STATE.AIR);
	}
#endregion
}


perform_move = function() {#region
	var _move = movement_calculate();
	var _x_move = _move[AXIS.X];
	var _y_move = _move[AXIS.Y];
			
	// COLLISION
	var _xbuff = 16;
	if (x + _x_move > 0+_xbuff) && (x + _x_move < room_width-_xbuff) x += _x_move;
	else {
		while (x + _x_move > 0+_xbuff) && (x + _x_move < room_width-_xbuff) x += sign(_x_move);
		movement_stop(AXIS.X);
	}

	var _ground = collision_rectangle(bbox_left,y+_y_move,bbox_right,y+_y_move,o_Ground,false,false);
	if (move_state == PLAYER_MOVE_STATE.AIR) && (_ground != noone) && (_ground.bbox_top > y) {
		y = _ground.bbox_top-1;
		movement_stop(AXIS.Y);
		change_state(PLAYER_MOVE_STATE.GROUND);
	}
	else if (y + _y_move < room_height) y += _y_move;
	else {
		while (y + _y_move < room_height) y += sign(_y_move);
		movement_stop(AXIS.Y);
		/////////////////////////////////////////////////////////////
		// THIS DOES NOT ACCOUNT FOR HITTING YOUR HEAD ON THINGS!!!!
		/////////////////////////////////////////////////////////////
		change_state(PLAYER_MOVE_STATE.GROUND);
	}
	
	if (move_state == PLAYER_MOVE_STATE.GROUND) && (place_meeting(x,y,o_Balcony)) {
		change_state(PLAYER_MOVE_STATE.WIN);	
	}
#endregion
}

perform_step = function() {
	player_input();
	switch(move_state){
		case PLAYER_MOVE_STATE.GROUND:
			move_hori = key_right - key_left;
			x_move = lerp(x_move,move_hori * move_speed,move_accel);
			// JUMP
			jump_check();
			// GROUND CHECK
			var _ground = collision_rectangle(bbox_left,y+1,bbox_right,y+1,o_Ground,false,false);
			if (_ground == noone) {
				change_state(PLAYER_MOVE_STATE.AIR);}
			// MOVE & COLLIDE
			perform_move();
		break;
		
		case PLAYER_MOVE_STATE.AIR:
			// lerp draw angle
			move_hori = key_right - key_left;
			if (swing_control_cd <= 0) x_move = lerp(x_move,move_hori * move_speed,move_accel);
			// JUMP
			jump_check();
			// GRAVITY
			move_gravity_total += move_gravity;
			if (y_move <= 0) move_gravity_total = min(move_gravity_total,move_gravity_max_up);
			else move_gravity_total = min(move_gravity_total,move_gravity_max_down);
			y_move += move_gravity_total;
			// MOVE & COLLIDE
			perform_move();
			// TIMERS
			if (swing_control_cd > 0) swing_control_cd -= 1;
			if (jump_cd > 0) jump_cd -=1;
		break;
		
		case PLAYER_MOVE_STATE.SWING:
			sine_wave_step(swing_struct);
			
			perform_swing();
			// TIMERS
			if (release_cd > 0) release_cd -= 1;
			//if (within_range(swing_struct.progress,swing_f_min1,swing_f_max1)) debug_draw = true;
			//else debug_draw = false;
		break;
		
		case PLAYER_MOVE_STATE.WIN:
			if (win_time == win_time_max) o_Transition.room_change(o_Transition.get_next_room());
			win_time += 1;
		break;
	}
	draw_coord_update();
	draw_angle = lerp(draw_angle,draw_angle_target,0.1);
	scale_step(scale_struct,60);
}