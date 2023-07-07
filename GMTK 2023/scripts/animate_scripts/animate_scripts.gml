enum ANIM_DIR
{
	FORWARD = 1,
	REVERSE = -1
}

/// @function	animate_create()
/// @desc		Creates animation variables in a struct and returns it
/// @param		sprite
///	@param		freeze_dicenum
/// @param		freeze_min
/// @param		freeze_max
/// @param		direction
function animate_create(_sprite = sprite_index,_freeze_dicenum = 1, _freeze_min = 0, _freeze_max = 0, _direction = ANIM_DIR.FORWARD){
#region
	var _image_num = sprite_get_number(_sprite);
	// Check speed of sprite
	var _speed = sprite_get_speed(_sprite);
	// If speed is 0, disable animation
	if (_speed == 0) 
	{
		var _anim_speed = 0;
		var _anim_time = -1; // will not animate.
	}
	// If not 0, set speed to sprite speed
	else
	{
		var _anim_speed = floor(FPS/sprite_get_speed(_sprite)); // this is NOT FPSecond. It's how many steps each frame is shown for
		// for best results sprite_speed should evenly divide into FPS
		var _anim_time = _anim_speed; // Only update frame to match speed with FPS
	}
	

	var _struct = 
	{
		anim_sprite : _sprite,
		anim_index : 0,
		anim_image_num : _image_num,
		anim_dir : clamp(_direction,-1,1), // does animation play forward (1) or backward (-1).
	
		anim_speed : _anim_speed,
		anim_time: _anim_time,

		anim_freeze_dice_num : _freeze_dicenum,
		anim_freeze_rand_min : _freeze_min,
		anim_freeze_rand_max : _freeze_max,
		// Method
		anim_freeze_method : function(){
				anim_freeze_max = 0;
				for (var _i = 0; _i < anim_freeze_dice_num; _i +=1)
				{
					anim_freeze_max += irandom(anim_freeze_rand_max) + anim_freeze_rand_min;
				}
				anim_freeze_time = anim_freeze_max;
			},
	};
	// Run method
	_struct.anim_freeze_method();
	
	return _struct;
#endregion
}

/// @func	animate_set_freeze()
///	@desc	Set freeze
/// @param	struct
///	@param	dice_num
///	@param	freeze_min
///	@param	freeze_max
function animate_set_freeze(_struct,_freeze_dicenum,_freeze_min,_freeze_max){
#region
	with(_struct)
	{
		anim_freeze_dice_num = _freeze_dicenum
		anim_freeze_rand_min = _freeze_min;
		anim_freeze_rand_max = _freeze_max;
		anim_freeze_method();
	}
#endregion
}

/// @func	animate_set_direction
/// @desc	Sets animation direction
/// @param	struct
/// @param	direction
/// @param	reset
/// @param	newonly
function animate_set_direction(_struct,_dir,_reset = true, _newonly = true){
#region
	with (_struct)
	{
		var _change = true;
		if (_newonly)
		{
			if (_dir == anim_dir) _change = false;
		}

		if (_change)
		{
			anim_dir = _dir;
			if (_reset)
			{
				switch (anim_dir)
				{
					case ANIM_DIR.FORWARD:
						anim_index = 0;
						anim_time = anim_speed; // Only update frame to match speed with FPS
						anim_freeze_method(); // Recalculate freeze
					break;
			
					case ANIM_DIR.REVERSE:
						anim_index = anim_image_num - 1;
						anim_time = anim_speed; // Only update frame to match speed with FPS
						anim_freeze_method(); // Recalculate freeze
					break;
				}
			}
		}
	}
#endregion
}

/// @function	animate_set_sprite()
/// @desc		Changes sprite. Returns true if sprite change occurs.
/// @param		struct
/// @param		sprite
/// @param		reset
/// @param		newonly
function animate_set_sprite(_struct,_sprite,_reset = true, _newonly = true){
#region
	with(_struct)
	{
		var _change = true;
		if (_newonly)
		{
			// Do not change if same sprite as current
			if (_sprite == anim_sprite) _change = false;
		}

		if (_change)
		{
			anim_sprite = _sprite;
			anim_image_num = sprite_get_number(anim_sprite);
			anim_speed = FPS/sprite_get_speed(anim_sprite); // this is NOT FPSecond. It's frames per STEP
			if (_reset) 
			{
				anim_index = 0;
				anim_time = anim_speed; // Only update frame to match speed with FPS
				anim_freeze_method(); // Recalculate freeze
			}
			// return true if change occurs
			return true;
		}
	}
#endregion
}

/// @func	animate_step()
/// @desc	Progresses animation vars by a step
/// @param	struct
function animate_step(_struct){
#region
	with(_struct)
	{
		// If time to incr frame, do so, then reset timer
		// Freeze allows animation to stop for a set amount of time after finishing (default is 0)

		if (anim_freeze_time > 0) anim_freeze_time -=1;
		// Only progress animation if freeze time is at 0
		else
		{
			// Count down animation time to next frame/image_index (assuming anim_time is on and not -1
			if (anim_time > 1) anim_time -=1;
			else if (anim_time == 1) 
			{
				// Note that anim_time > 1. On ONE, it's time to change frames. This is because the frame it is SET to 1, it is also displayed.
				// Setting it to zero would end up showing it for anim_speed steps + an extra step on the step where it was set.
				switch (anim_dir)
				{
					case ANIM_DIR.FORWARD:
						{
							anim_index += 1;
							anim_time = anim_speed;
						}
						// If animation reaches end, reset, and reset freeze time
						if (anim_index > anim_image_num-1) 
						{
							anim_index = 0;
							anim_freeze_method();
						}
					break;
		
					case ANIM_DIR.REVERSE:
						{
							anim_index -= 1;
							anim_time = anim_speed;
						}
						// If animation reaches start, reset, and reset freeze time
						if (anim_index < 0) 
						{
							anim_index = anim_image_num-1;
							anim_freeze_method();
						}
					break;
				}
			}
		}
	}
#endregion
}

/// @function	animate_frame_end_check()
/// @desc		Checks to see if animation just finished a frame. Should be run AFTER animate_step for accuracy
/// @param		struct
function animate_frame_end_check(_struct){
#region
	with(_struct)
	{
		// RUNS AFTER animate_step
		if (anim_time == anim_speed) return true;
	}
#endregion
}

/// @function	animate_end_check()
/// @desc		Checks to see if animation is on last frame of last image_num(index)
/// @param		struct
function animate_end_check(_struct){
#region
	with (_struct)
	{
		switch (anim_dir)
		{
			case ANIM_DIR.FORWARD:
				var _index = anim_image_num - 1;
			break;
	
			case ANIM_DIR.REVERSE:
				var _index = 0;
			break;
		}
	
		if ((anim_index == _index) && ((anim_time == 1 ) || (anim_time == -1))) return true;
		else return false;
	}
#endregion
}

/// @function	animate_pause()
///	@desc		Stops animation
/// @param		struct
function animate_pause(_struct){
#region
	with(_struct)
	{
		if (anim_time != -1) anim_time = -1;
	}
#endregion
}

/// @function	animate_unpause()
///	@desc		Resumes animation
/// @param		struct
function animate_unpause(_struct){
#region
	with(_struct)
	{
		if (anim_time == -1) anim_time = anim_speed;
	}
#endregion
}

///@function	animate_unfreeze()
///@desc		Sets freeze time to 0 to trigger animation with optional _permanent paramater.
/// @param		struct
/// @param		permanent
function animate_unfreeze(_struct,_permanent = false){
#region
	with(_struct)
	{
		anim_freeze_time = 0;
		// Set all freeze times to 0 if permanent unfreeze
		if (_permanent)
		{
			anim_freeze_rand_min = 0;
			anim_freeze_rand_max = 0;
			anim_freeze_max = 0;
		}
	}
#endregion
}