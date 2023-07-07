/*
// Sine Wave Variables
	output = 0; // Output
	progress = 0; // Progress
	amplitude = 32; // Intensity of wave
	wave_length = 30; // Time between a full wave (up AND down)
	accel = 0.1; // Optional for lerping
	
// Without Lerp
	output = amplitude * sin(progress);
	progress += (pi / wave_length);
	if (progress >= (2*pi)) progress = 0;

// With Lerp
	output = lerp(hover_y,amplitude * sin(progress),accel);
	progress += (pi / wave_length);
	if (progress >= (2*pi)) progress = 0;
*/

/// @function		sine_wave_create()
/// @description	Creates sine wave variables in a struct
/// @param			_amp
/// @param			_length
/// @param			_randstart
function sine_wave_create(_amp,_length,_randstart = false,_start = 0){
	if (_randstart) var _prog = irandom(2*pi);
	else var _prog = _start;
	var _struct =
	{
		output : 0,
		progress_start : _start,
		progress : _prog,
		amplitude : _amp,
		wave_length : _length
	}
	with (_struct) {ouput = amplitude * sin(progress);}
	return _struct;
}

/// @function		sine_wave_step()
/// @description	Progresses a sine_wave
/// @param			_struct
function sine_wave_step(_struct){
	with (_struct)
	{
		output = amplitude * sin(progress);
		progress += (pi / wave_length);
		if (progress >= (2*pi)) progress = 0;
	}
}

/// @function		sine_wave_reset()
/// @description	Resets a sine_wave
/// @param			_struct
function sine_wave_reset(_struct){
	with (_struct)
	{
		progress = progress_start;
		output = 0;
	}
}