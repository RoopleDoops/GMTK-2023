draw_hair();
scale_draw_ext(scale_struct,sprite_index,image_index,draw_x,draw_y,draw_scalex,1,draw_angle,image_blend,image_alpha);
if (debug_mode) {
	//scale_draw_ext(scale_struct,s_PlayerDebug,0,x,y,1,1,draw_angle,image_blend,image_alpha);
	//draw_set_color(col_white);
	
	//draw_point(x,y+head_y_difference);
	//draw_text(x,y,string(x)+","+string(y));
	//draw_text(x-96,y,"PROG:"+string(swing_struct.progress));
	//if(debug_draw) && (debug_mode) draw_sprite(s_PlayerHair,0,draw_x,draw_y);
	//draw_text(x-96,y,"VX:"+string(x_move));
	//draw_text(x-96,y+32,"VY:"+string(y_move));
	//if (swing_control_cd > 0) draw_text(x,bbox_top-32,string(swing_control_cd));
}
