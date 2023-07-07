///@func	digit_place()
///@desc	Returns the digit at the specified place in a number.
///@param	_num
///@param	_place
function digit_place(_num,_place){
#region
	// _num refers to the place in a number starting with 1 and incrementing.
	// E.g. 1, 10, 100, 1000, etc.
	
	// Use mod to get number to the place. Ex. 576 to the 100th place becomes 500.
	var _digit = (_num mod (_place * 10)) - (_num mod _place);
	// Then use log to simplify to a single digit. Ex. 500 becomes 5.
	var _digit = _digit / power(10,(floor(log10(_digit))));
	
	return _digit;
#endregion
}


///@func	within_range()
///@desc	Checks to see if value _val is within range _r1 and _r2 (inclusive)
///@param	_val
///@param	_r1
///@param	_r2
///@param	_inclusive
function within_range(_val,_r1,_r2,_inclusive = true){
#region
	if (_r1 < _r2)
	{
		var _min = _r1;
		var _max = _r2;
	}
	else
	{
		var _min = _r2;
		var _max = _r1;
	}
	
	switch (_inclusive)
	{
		case true:
			if (_val >= _min) && (_val <= _max) return true;
		break;
		
		case false:
			if (_val > _min) && (_val < _max) return true;
		break;
	}
#endregion
}

///@func	angle_normalize()
///@desc	Converts an angle to a 0-359 value
function angle_normalize(_angle){
#region
	while (_angle < 0) _angle += 360;
	_angle = _angle mod 360;
	return _angle;
#endregion
}

///@func	angle_inverse()
///@desc	Inverts an angle to its 180 degree opposite and converts to 0-359
function angle_inverse(_angle){
#region
	_angle = angle_normalize(_angle);
	_angle += 180;
	_angle = angle_normalize(_angle);
	return _angle;
#endregion
}

///@func	angle_dir_hori()
///@desc	Converts an angle to a left (-1) or right (1) horizontal direciton.
function angle_dir_hori(_angle){
_angle = angle_normalize(_angle);

if (within_range(_angle,0,90)) return 1;
else if (within_range(_angle,91,270)) return -1;
else return 1;

}

///@func	angle_dir_vert()
///@desc	Converts an angle to an up (-1) or down (1) vertical direciton.
function angle_dir_vert(_angle){
_angle = angle_normalize(_angle);

if (within_range(_angle,0,179)) return 1;
else return -1;

}

///@func	round_decimal()
///@desc	Rounds a number to _places number of decimal places
			//ie num 1.23456 to 2 places gets you 1.23
function round_decimal(_num,_places){
	var _factor = power(10, _places);
	var _floor = floor(_num*_factor);
	var _newnum = _floor/_factor;
	return _newnum;
}

///	@func	max_abs()
///	@desc	Returns the number with the max absolute value
function max_abs(_num1,_num2)
{
	if (abs(_num1) > abs(_num2)) return _num1;
	else return _num2;
}