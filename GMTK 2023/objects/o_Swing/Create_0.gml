radius = 96;
col_extra = 16;
col_radius = radius + col_extra;
color_default = col_blue3;
color_active = col_blue1;
color = color_default;

check_swing = function(_x,_y) {
	// Check radius but only if player is at or below swing center (give some wiggle room)
	if (_y >= y-col_extra) return point_in_circle(_x,_y,x,y,col_radius);
}

check_player_near = function() {
	var _player_near = false;
	if (instance_exists(o_Player)) {
		_player_near = check_swing(o_Player.x,o_Player.get_y_middle());
	}
	if (_player_near) color = color_active;
	else color = color_default;
}

perform_step = function() {
	check_player_near();
}
