event_inherited();
movement_create();
move_speed = 2;
y_limit = 200;
yend = ystart + y_limit;
y_move = move_speed;
move_speed_target = move_speed;
move_accel = 0.05;

perform_move = function() {
	move_speed = lerp(move_speed,move_speed_target,move_accel);
	y_move = move_speed;
	var _move = movement_calculate();
	var _x_move = _move[AXIS.X];
	var _y_move = _move[AXIS.Y];
	
	if (y + _y_move <= yend) && (y + _y_move >= ystart) y += _y_move;
	else {
		if (sign(_y_move) == 1) y = yend; // moving down
		else y = ystart; // moving up
		move_speed_target = -move_speed_target;
	}	
}

perform_step = function() {
	perform_move();
	
	check_player_near();
}
