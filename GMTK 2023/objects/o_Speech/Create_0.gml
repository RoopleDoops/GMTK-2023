speech_prog = 0;

draw_speech = function() {
	switch (speech_prog) {
	case 1:
		draw_sprite(s_Speech1,0,x,y);
	break;
	case 2:
		draw_sprite(s_Speech2,0,x,y);
	break;
	default:
	break;
	}
}