scale_draw(scale_struct,x,y);
draw_set_color(col_white);
draw_text(x,y,string(x)+","+string(y));
draw_text(x-96,y,"VX:"+string(x_move));
draw_text(x-96,y+32,"VY:"+string(y_move));
if (swing_control_cd > 0) draw_text(x,bbox_top-32,string(swing_control_cd));
