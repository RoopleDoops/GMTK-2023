radius = 96;
color_extra = 10; // extra collision on color for player swinging (helps prevent flashing)
col_extra = 20;
col_radius = radius + col_extra;
color_default = col_blue3;
color_active = col_blue1;
color = color_default;

check_swing = function(_x1,_x2,_y1,_y2,_extra = 0) {
	// Check radius but only if player is at or below swing center (give some wiggle room)
	var _inside = false;
	if (_y2 >= y) {
		if (point_in_circle(_x1,_y1,x,y,radius+_extra)) _inside = true;
		else if (point_in_circle(_x2,_y1,x,y,radius+_extra)) _inside = true;
		else if (point_in_circle(_x1,_y2,x,y,radius+_extra)) _inside = true;
		else if (point_in_circle(_x2,_y2,x,y,radius+_extra)) _inside = true;
	}
	return _inside;
}

check_player_near = function() {
	var _player_near = false;
	if (instance_exists(o_Player)) {
		var _p = o_Player;
		_player_near = check_swing(_p.bbox_left,_p.bbox_right,_p.bbox_top,_p.bbox_bottom,color_extra);
	}
	if (_player_near) color = color_active;
	else color = color_default;
}

perform_step = function() {
	check_player_near();
}
