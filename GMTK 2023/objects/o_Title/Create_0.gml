


perform_step = function() {
	if (o_InputManager.get_input_pressed(INPUT.ACTION)) {
		o_Transition.room_change(r_L1);
	}
}