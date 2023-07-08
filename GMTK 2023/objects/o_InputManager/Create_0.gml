enum INPUT {
	LEFT,
	RIGHT,
	DOWN,
	UP,
	ACTION
}

input_enabled = true;
key_left = 0;
key_right = 0;
key_down = 0;
key_up = 0;
key_action = 0;
key_left_pressed = 0;
key_right_pressed = 0;
key_down_pressed = 0;
key_up_pressed = 0;
key_action_pressed = 0;

get_input_press = function(_input){
	if (input_enabled){
		switch(_input){
			case INPUT.LEFT:
				key_left = keyboard_check_direct(ord("A"));
				return key_left;
			break;
			case INPUT.RIGHT:
				key_right = keyboard_check_direct(ord("D"));
				return key_right;
			break;
			case INPUT.UP:
				key_up = keyboard_check_direct(ord("W"));
				return key_up;
			break;
			case INPUT.DOWN:
				key_down = keyboard_check_direct(ord("S"));
				return key_down;
			break;
			case INPUT.ACTION:
				key_action = keyboard_check_direct(vk_space);
				return key_action;
			break;
		}
	}
	else return false;
}

get_input_pressed = function(_input){
	if (input_enabled){
		switch(_input){
			case INPUT.LEFT:
				key_left_pressed = keyboard_check_pressed(ord("A"));
				return key_left_pressed;
			break;
			case INPUT.RIGHT:
				key_right_pressed = keyboard_check_pressed(ord("D"));
				return key_right_pressed;
			break;
			case INPUT.UP:
				key_up_pressed = keyboard_check_pressed(ord("W"));
				return key_up_pressed;
			break;
			case INPUT.DOWN:
				key_down_pressed = keyboard_check_pressed(ord("S"));
				return key_down_pressed;
			break;
			case INPUT.ACTION:
				key_action_pressed = keyboard_check_pressed(vk_space);
				return key_action_pressed;
			break;
		}
	}
	else return false;
}

set_input = function(_enabled){
	input_enabled = _enabled;
}

