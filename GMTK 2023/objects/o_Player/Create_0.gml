movement_create();
move_speed = 6;
move_gravity = 0.25;
move_gravity_total = 0;
move_gravity_max = 0.5;
jump_power = -10;
jump_max = 2;
jump_left = jump_max;
// STATE MACHINE NEEDED FOR SWINGING AND JUMPING
enum PLAYER_MOVE_STATE {
	GROUND,
	AIR,
	SWING
}
move_state = PLAYER_MOVE_STATE.AIR;

change_state = function(_state){
	switch(_state){
		case PLAYER_MOVE_STATE.GROUND:
			move_gravity_total = 0;
			jump_left = jump_max;
			movement_stop(AXIS.Y);
		break;
		case PLAYER_MOVE_STATE.AIR:
			
		break;
		case PLAYER_MOVE_STATE.SWING:
			
		break;
	}
	move_state = _state;
}

key_left = 0;
key_right = 0;
key_up = 0;
key_down = 0;
key_action = 0;
move_hori = 0;
move_vert = 0;


player_input = function() {
	key_left = o_InputManager.get_input_press(INPUT.LEFT);
	key_right = o_InputManager.get_input_press(INPUT.RIGHT);
	key_up = o_InputManager.get_input_press(INPUT.UP);
	key_down = o_InputManager.get_input_press(INPUT.DOWN);
	key_action = o_InputManager.get_input_pressed(INPUT.ACTION);
}

jump_check = function() {
	if (key_action) perform_jump();
}
perform_jump = function() {
	if (jump_left > 0) {
		jump_left -= 1;
		y_move = jump_power;	
		change_state(PLAYER_MOVE_STATE.AIR);
	}
}

perform_step = function() {
	player_input();
	
	switch(move_state){
		case PLAYER_MOVE_STATE.GROUND:
			move_hori = key_right - key_left;
			x_move = move_hori * move_speed;
			// JUMP
			jump_check();
			
			var _move = movement_calculate();
			var _x_move = _move[AXIS.X];
			var _y_move = _move[AXIS.Y];
			
			// COLLISION
			x += _x_move;
			y += _y_move;
		break;
		
		case PLAYER_MOVE_STATE.AIR:
			move_hori = key_right - key_left;
			x_move = move_hori * move_speed;
			// JUMP
			jump_check();
			// GRAVITY
			move_gravity_total += move_gravity;
			move_gravity_total = min(move_gravity_total,move_gravity_max);
			y_move += move_gravity_total;
			
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
		break;
		
		case PLAYER_MOVE_STATE.SWING:
		break;
		
	}
}