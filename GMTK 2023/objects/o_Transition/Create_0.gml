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

change_state = function(_state,_time) {
	switch(_state) {
		case TRANS_STATE.TO_BLACK:
			draw_alpha_target = 1;
			lerp_reset(fade_lerp);
		break;
		case TRANS_STATE.TO_CLEAR:
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
		break;
		case TRANS_STATE.TO_CLEAR:
		break;
		case TRANS_STATE.DONE:
		break;
	}
	lerp_step(fade_lerp);
	draw_alpha = 1 - fade_lerp.lerp_value;
	if (lerp_finished(fade_lerp)) change_state(TRANS_STATE.DONE);
}