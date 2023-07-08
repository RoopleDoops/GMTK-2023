draw_set_color(c_white);
if (move_accel_target == move_accel_fast) draw_set_color(c_orange);
draw_rectangle(x-camera_frame_val,y-camera_frame_val,x+camera_frame_val,y+camera_frame_val,true);
draw_rectangle(x-camera_frame_val_centered,y-camera_frame_val_centered,x+camera_frame_val_centered,y+camera_frame_val_centered,true);