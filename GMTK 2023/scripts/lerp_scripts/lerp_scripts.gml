/// @function		lerp_create()
/// @description	Creates lerp variables in a struct
/// @param			_start
/// @param			_target
/// @param			_incr
/// @param			_prog
function lerp_create(_start,_target,_incr,_prog = 0){
	var _struct =
	{
		lerp_value : _start,
		lerp_start : _start,
		lerp_target : _target,
		lerp_incr : _incr,
		lerp_prog : _prog
	}
	return _struct;
}

/// @function		lerp_change()
/// @description	Changes lerp variables in a struct
/// @param			_struct
/// @param			_start
/// @param			_target
/// @param			_incr
/// @param			_prog
function lerp_change(_struct,_start = _struct.lerp_start,_target = _struct.lerp_target,_incr = _struct.lerp_incr,_prog = 0){
	with (_struct)
	{
		lerp_value = _start;
		lerp_start = _start;
		lerp_target = _target;
		lerp_incr = _incr;
		lerp_prog = _prog;
	}
}

/// @function		lerp_step()
/// @description	Progresses a lerp struct
/// @param			_struct
function lerp_step(_struct,_incr = _struct.lerp_incr){
	with (_struct)
	{
		if (lerp_value != lerp_target)
		{
			lerp_prog = clamp(lerp_prog + lerp_incr,0,1);
			lerp_value = lerp_start + ((lerp_target - lerp_start) * lerp_prog);
		}
	}
}

/// @function		lerp_finished()
///	@description	Checks if a lerp value is at target
/// @param			_struct
function lerp_finished(_struct){
	with (_struct)
	{
		if (lerp_value == lerp_target) return true;
	}
}
