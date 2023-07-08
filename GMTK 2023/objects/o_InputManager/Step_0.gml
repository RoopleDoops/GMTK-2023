if (debug_mode)
{
#region Debug Control
	// GAME SLOW
	if (keyboard_check(vk_control))
	{
		if (keyboard_check_pressed(ord("1"))) game_set_speed(60, gamespeed_fps);
		else if (keyboard_check_pressed(ord("2"))) game_set_speed(30, gamespeed_fps);
		else if (keyboard_check_pressed(ord("3"))) game_set_speed(15, gamespeed_fps);
		else if (keyboard_check_pressed(ord("4"))) game_set_speed(5, gamespeed_fps);
		else if (keyboard_check_pressed(ord("5"))) game_set_speed(2, gamespeed_fps);
		else if (keyboard_check_pressed(ord("6"))) game_set_speed(1, gamespeed_fps);
		else if (keyboard_check_pressed(ord("R"))) game_restart();
	}
#endregion
}