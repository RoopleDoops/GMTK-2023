radius = 96;
color_extra = 10; // extra collision on color for player swinging (helps prevent flashing)
col_extra = 20;
col_radius = radius + col_extra;
active = false;
color_alpha_default = 0.25;
color_alpha_active = 0.4;
color_alpha = color_alpha_default;
color_default = col_green2;
color_active = col_green1;
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
	if (instance_exists(o_Player)) {
		var _p = o_Player;
		active = 
		(o_Player.my_swing == id)
		|| ((check_swing(_p.bbox_left,_p.bbox_right,_p.bbox_top,_p.bbox_bottom,color_extra)) 
			&& (o_Player.move_state == PLAYER_MOVE_STATE.AIR));
	}
	else active = false;
	
	if (active) {color = color_active; color_alpha = color_alpha_active;}
	else {color = color_default; color_alpha = color_alpha_default;}
}

perform_step = function() {
	check_player_near();
}
