event_inherited();
movement_create();
move_speed = 4;
//x_limit = 200; //var def
xend = xstart + x_limit;
x_move = move_speed;
move_speed_target = move_speed;
move_accel = 0.05;

perform_move = function() {
	move_speed = lerp(move_speed,move_speed_target,move_accel);
	x_move = move_speed;
	var _move = movement_calculate();
	var _x_move = _move[AXIS.X];
	var _y_move = _move[AXIS.Y];
	
	if (x + _x_move <= xend) && (x + _x_move >= xstart) x += _x_move;
	else {
		if (sign(_x_move) == 1) x = xend; // moving right
		else x = xstart; // moving left
		move_speed_target = -move_speed_target;
	}	
}

perform_step = function() {
	perform_move();
	
	check_player_near();
}
