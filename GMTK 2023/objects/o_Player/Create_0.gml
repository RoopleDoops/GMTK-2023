movement_create();
//////////////////////////////////
//////////////////////////////////
// PLAYER MOVEMENT NEEDS LERPING 
///////////////////////////////
////////////////////////////////
scale_struct = scale_create();
move_speed = 5;
move_accel = 0.05;
move_gravity = 0.2;
move_gravity_total = 0;
move_gravity_max_up = 0.3;
move_gravity_max_down = 0.4;
jump_power = -8;
jump_max = 1;
jump_left = jump_max;
swing_power = 12;
my_swing = noone;
swing_struct = sine_wave_create(90,60); // set wave to +/-90(deg). Full cycle takes 90 frames

swing_control_cd_max = 15; // how long after swing before player can move horizontally
swing_control_cd = swing_control_cd_max;

get_y_middle = function() {
	return (bbox_top+bbox_bottom)/2;	
}

// STATE MACHINE
enum PLAYER_MOVE_STATE {
	GROUND,
	AIR,
	SWING
}
move_state = PLAYER_MOVE_STATE.AIR;
change_state = function(_state){#region
	switch(_state){
		case PLAYER_MOVE_STATE.GROUND:
			squash_scale(scale_struct);
			swing_control_cd = 0;
			move_gravity_total = 0;
			jump_left = jump_max;
			movement_stop(AXIS.Y);
		break;
		case PLAYER_MOVE_STATE.AIR:
			squash_scale(scale_struct);
		break;
		case PLAYER_MOVE_STATE.SWING:
			squash_scale(scale_struct);
			swing_control_cd = 0;
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
			// NEW POS GET
			// MUST USE COL radius for this or else the player will snap to the wrong place
			// when collision picks it up but it's outside the actual rotation radius
			x = clamp(x,_swingx-_swingrcol,_swingx+_swingrcol); // clamp position to within half circle
			if (x > _swingx) var _dir = 360 - darccos((x-_swingx)/_swingrcol);
			else var _dir = 180 + darccos((_swingx-x)/_swingrcol);
			
			// OLD POS GET
			// check max for y to make sure player doesn't to point above swing when using col_extra leniency
			//var _dir = point_direction(_swingx,_swingy,x,max(_swingy,y));
			x = floor(_swingx + lengthdir_x(_swingr,_dir));
			y = floor(_swingy + lengthdir_y(_swingr,_dir) + (y - get_y_middle()));
			
			if (x >= _swingx) var _wavedir = -1; // swing left towards center
			else var _wavedir = 1; // swing right towards center
			var _output = _dir - 270;
			var _prog = arcsin(_output/swing_struct.amplitude)*_wavedir;
			sine_wave_set(swing_struct,_prog,_wavedir);
		break;
	}
	move_state = _state;
#endregion
}
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
	if (key_action) {
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
	x = floor(_swingx + lengthdir_x(_swingr,_dir));
	y = floor(_swingy + lengthdir_y(_swingr,_dir) + (y - get_y_middle()));
#endregion
}

perform_swing = function() {#region
	swing_snap();
	
	with (my_swing) {
		var _swingx = x;
		var _swingy = y;
		var _swingr = radius;
	}
	
	if (key_action) {
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
		change_state(PLAYER_MOVE_STATE.AIR);
	}
#endregion
}


perform_move = function() {#region
	var _move = movement_calculate();
	var _x_move = _move[AXIS.X];
	var _y_move = _move[AXIS.Y];
			
	// COLLISION
	x += _x_move;
	if (y + _y_move < room_height) y += _y_move;
	else {
		while (y + _y_move < room_height) y += sign(_y_move);
		movement_stop(AXIS.Y);
		/////////////////////////////////////////////////////////////
		// THIS DOES NOT ACCOUNT FOR HITTING YOUR HEAD ON THINGS!!!!
		/////////////////////////////////////////////////////////////
		change_state(PLAYER_MOVE_STATE.GROUND);
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
			// MOVE & COLLIDE
			perform_move();
		break;
		
		case PLAYER_MOVE_STATE.AIR:
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
		break;
		
		case PLAYER_MOVE_STATE.SWING:
			sine_wave_step(swing_struct);
			
			perform_swing();
		break;
	}
	scale_step(scale_struct,60);
}