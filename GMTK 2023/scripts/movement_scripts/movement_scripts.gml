#macro TERM_VELOC 32

enum AXIS
{
	X,
	Y
}

function movement_create(){
	x_move = 0;
	y_move = 0;
	
	x_move_bank = 0;
	y_move_bank = 0;
	
	x_knock = 0;
	y_knock = 0;
}

function movement_calculate(){
	// Add Knock
	x_move += x_knock;
	y_move += y_knock;
	
	#region Hypotenuse Clamp
		var _dir = point_direction(x,y,x+x_move,y+y_move);
		var _dist =  point_distance(x,y,x+x_move,y+y_move);
		_dist = clamp(_dist,0,TERM_VELOC);
		var _xclamp = lengthdir_x(_dist,_dir);
		var _yclamp = lengthdir_y(_dist,_dir);
		x_move = clamp(x_move,-abs(_xclamp),abs(_xclamp));
		y_move = clamp(y_move,-abs(_yclamp),abs(_yclamp));
	#endregion
	
	#region X & Y Bank
		x_move_bank += x_move;
		// Clamp x_move_bank to terminal velocity
		x_move_bank = clamp(x_move_bank,-TERM_VELOC,TERM_VELOC);
		var _x_move = sign(x_move_bank) * floor(abs(x_move_bank));
		x_move_bank -= _x_move;
		// Knockback decay
		if (x_knock != 0) x_knock = 0;
	
		y_move_bank += y_move;
		// Clamp y_move_bank to terminal velocity
		// FALLING Y TERMINAL VELOCITY IS REDUCED
		y_move_bank = clamp(y_move_bank,-TERM_VELOC,(TERM_VELOC/3));
		var _y_move = sign(y_move_bank) * floor(abs(y_move_bank));
		y_move_bank -= _y_move;
		// Knockback decay
		if (y_knock != 0) y_knock = 0;
	#endregion
	
	// Store and Return
	var _array = [];
	_array[AXIS.X] = _x_move;
	_array[AXIS.Y] = _y_move;
	
	return _array;
}

function movement_stop(_axis){
	switch(_axis){
		case AXIS.X:
			x_move = 0;
			x_move_bank = 0;
			x_knock = 0;
		break;
		case AXIS.Y:
			y_move = 0;
			y_move_bank = 0;
			y_knock = 0;
		break;
	}
}