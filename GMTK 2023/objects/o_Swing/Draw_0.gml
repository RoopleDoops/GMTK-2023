draw_sprite_ext(sprite_index,0,x,y,1,1,0,color,1);
draw_set_color(color);
draw_circle(x,y,radius,true);
draw_line(x-radius,y,x+radius,y);
draw_set_color(c_black);
draw_rectangle(x-radius,y-1,x+radius,y-radius,false);