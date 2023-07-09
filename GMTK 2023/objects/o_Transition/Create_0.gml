depth = DEPTH_TRANSITION

enum TRANS_STATE {
	TO_BLACK,
	TO_CLEAR,
	DONE
}

draw_color = c_black;
draw_alpha = 1;
draw_alpha_target = 1;
lerp_time = 60;
lerp_incr = 1/lerp_time;
fade_lerp = lerp_create(0,1,lerp_incr);
state = TRANS_STATE.TO_CLEAR;
room_to = noone;

room_change = function(_room) {
	change_state(TRANS_STATE.TO_BLACK);
	room_to = _room;
}

get_next_room = function() {
	switch (room) {
		case r_L1: return r_L2; break;
		case r_L2: return r_L3; break;
		default: return r_Title; break;
	}
}


change_state = function(_state,_time) {
	switch(_state) {
		case TRANS_STATE.TO_BLACK:
			o_InputManager.set_input(false);
			draw_alpha_target = 1;
			lerp_reset(fade_lerp);
		break;
		case TRANS_STATE.TO_CLEAR:
			o_InputManager.set_input(false);
			draw_alpha_target = 0;
			lerp_reset(fade_lerp);
		break;
		case TRANS_STATE.DONE:
		break;
	}
	state = _state;
}

change_state(TRANS_STATE.TO_CLEAR);

perform_step = function() {
	switch(state) {
		case TRANS_STATE.TO_BLACK:
			lerp_step(fade_lerp);
			draw_alpha = fade_lerp.lerp_value;
			if (lerp_finished(fade_lerp)) {
				if (room_to != noone) {
					room_goto(room_to);
					room_to = noone;
				}
				change_state(TRANS_STATE.DONE);
			}
		break;
		case TRANS_STATE.TO_CLEAR:
			lerp_step(fade_lerp);
			draw_alpha = 1 - fade_lerp.lerp_value;
			if (lerp_finished(fade_lerp)) {
				o_InputManager.set_input(true);
				change_state(TRANS_STATE.DONE);
			}
		break;
		case TRANS_STATE.DONE:
		break;
	}
	
}