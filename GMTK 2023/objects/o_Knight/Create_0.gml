scale_struct = scale_create();
face_dir = 1;
dir_change_cd_max = 10;
dir_change_cd = 0;
speech_prog = 0;
speech_yoffset = -24;
my_speech = instance_create_depth(x,y+speech_yoffset,DEPTH_SPEECH,o_Speech);
sound_talk = noone;

draw_shakex = 0;
draw_shakex_max = 1;
draw_shake_freq_base = 2; // how many frames in between each shake.
draw_shake_freq = draw_shake_freq_base;

progress_speech = function(_prog) {
	if (_prog == 1) || (_prog == 2) {
		var _pitch = choose(0.9,1,1.1);
		sound_talk = audio_play_sound(sfx_knight_talk,80,false);
		audio_sound_pitch(sound_talk,_pitch);	
	}
	my_speech.speech_prog = _prog;
	squash_scale(scale_struct,1.2,0.8);
}

perform_step = function() {
	if (instance_exists(o_Player)) {
		if (o_Player.x > x) && (face_dir != 1) { 
			if (dir_change_cd <= 0) {
				face_dir = 1; squash_scale(scale_struct,1.2,0.8); dir_change_cd = dir_change_cd_max;}
		}
		else if (o_Player.x < x) && (face_dir != -1) {
			if (dir_change_cd <= 0) {
				face_dir = -1; squash_scale(scale_struct,1.2,0.8); dir_change_cd = dir_change_cd_max;}
		}
	}
	if (my_speech.speech_prog == 2) && (room != r_L4) {
		if (draw_shake_freq > 0) draw_shake_freq -= 1;
		else
		{
			if (draw_shakex == 0) draw_shakex = draw_shakex_max;
			else draw_shakex = -sign(draw_shakex) * draw_shakex_max;
			draw_shake_freq = draw_shake_freq_base;
		}	
	}
	else draw_shakex = 0;
	
	if (dir_change_cd > 0) dir_change_cd -= 1;
	scale_step(scale_struct,60);
}