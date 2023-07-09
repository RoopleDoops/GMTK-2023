speech_prog = 0;

draw_speech = function() {
	switch (speech_prog) {
	case 1:
		draw_sprite(s_Speech1,0,x,y);
	break;
	case 2:
		if (room == r_L1) draw_sprite(s_Speech2,0,x,y);
		else if (room == r_L2) draw_sprite(s_Speech2b,0,x,y);
		else if (room == r_L3) draw_sprite(s_Speech2c,0,x,y);
		else if (room == r_L4) draw_sprite(s_Speech2d,0,x,y);
	break;
	case 3:
		draw_sprite(s_Speech3,0,x,y);
	break;
	default:
	break;
	}
}