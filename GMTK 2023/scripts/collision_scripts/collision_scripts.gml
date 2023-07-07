///@function	collision_line_bbox_list()
///@desc		Checks for line collision on all bbox points of the calling instance and returns a single ds list without duplicates.
///@param		_x1
///@param		_y1
///@param		_x2
///@param		_y2
///@param		_obj
///@param		_prec
///@param		_notme
///@param		_list
///@param		_ordered
///@param		_mask_expand
function collision_line_bbox_list(_x1,_y1,_x2,_y2,_obj,_prec,_notme,_listmaster,_ordered,_mask_expand = 0){
#region
	var _listbr = ds_list_create();
	var _listbl = ds_list_create();
	var _listbt = ds_list_create();
	var _listbb = ds_list_create();

	// Get difference between x/y coords for use in defining line
	var _xadd = _x2 - _x1;
	var _yadd = _y2 - _y1;
	// Moves to new coords to get bbox_data
	var _xprev = x;
	var _yprev = y;
	x = _x1;
	y = _y1;

		// Collision line from all bbox points into a single list, without duplicates.
		for (var _bbox = 0; _bbox < 4; _bbox += 1)
		{
			switch (_bbox)
			{
				case 0: var _list = _listbr; var _x = bbox_left-_mask_expand; var _y = y; break; // bbox_left
				case 1: var _list = _listbl; var _x = bbox_right+_mask_expand; var _y = y; break; // bbox_right
				case 2: var _list = _listbt; var _x = x; var _y = bbox_top-_mask_expand; break; // bbox_top
				case 3: var _list = _listbb; var _x = x; var _y = bbox_bottom+_mask_expand; break; // bbox_bottom
			}
	
			var _objnum = collision_line_list(_x,_y,_x+_xadd,_y+_yadd,_obj,_prec,_notme,_list,_ordered);
			for (var _i = 0; _i < _objnum; _i += 1)
			{
				var _inst = _list[| _i];
				// If inst is not in master list, add it
				if (ds_list_find_index(_listmaster,_inst) == -1) ds_list_add(_listmaster,_inst);
			}
		}

	// Return to original x/y coords and clean up lists
	x = _xprev;
	y = _yprev;

	ds_list_destroy(_listbr);
	ds_list_destroy(_listbl);
	ds_list_destroy(_listbt);
	ds_list_destroy(_listbb);

	// Return number of instances in list
	var _size = ds_list_size(_listmaster);
	return _size;
#endregion
}

///@function	collision_points_object()
///@desc		Checks for collision with _object and returns true if _numpoints+ bbox are colliding
///@param		object
///@param		numpoints
function collision_points_object(_object,_numpoints = 4){
	#region
		// Set collision points and boxes to 0/false
		var _points = 0;
		// Check each point, adding up points and keeping track of which point touch
		if (collision_point(bbox_left,y,_object,false,false)) _points += 1;
		if (collision_point(bbox_right,y,_object,false,false)) _points += 1;
		if (collision_point(x,bbox_top,_object,false,false)) _points += 1;
		if (collision_point(x,bbox_bottom,_object,false,false)) _points += 1;
		// If more than 3 points touch, return true
		if (_points >= _numpoints)
		{
			return true;
		}
		else return false;
	#endregion
}

///@function	collision_point_tile()
///@desc		Checks for collision with _tile on _layer and returns true if point is colliding
///@param		x
///@param		y
///@param		layer
///@param		tile
function collision_point_tile(_x,_y,_layer,_tile){
	#region
	var _tmap = layer_tilemap_get_id(_layer);

	// Check each point, adding up points and keeping track of which point touch
	var _tdata = tilemap_get_at_pixel(_tmap,_x,_y);
		var _tindex = tile_get_index(_tdata);
		if (_tindex == _tile) return true;
		else return false;
	#endregion
}

///@function	collision_point_tile_impassable()
///@desc		Checks for collision with all "impassable" tiles on _layer and returns true if point collidess
///@param		x
///@param		y
///@param		layer
function collision_point_tile_impassable(_x,_y,_layer){
	#region
	var _tmap = layer_tilemap_get_id(_layer);
	
	var _tx = tilemap_get_cell_x_at_pixel(_tmap,_x,_y),
	var	_ty = tilemap_get_cell_y_at_pixel(_tmap,_x,_y),

	if (!tile_passable(_tmap,_tx,_ty)) return true;
	#endregion
}

///@function	place_meeting_tile_impassable()
///@desc		Checks for collision with all "impassable" tiles on _layer and returns true if bounding box collides
///@param		x
///@param		y
///@param		layer
function place_meeting_tile_impassable(_x,_y,_layer){
	#region
	// Save x/y values
	var _prevx = x;
	var _prevy = y;
	// Assign new x/y values to check collision from
	x = _x;
	y = _y;
	// Save bbox at new x/y
	var _bl = bbox_left;
	var _br = bbox_right;
	var _bt = bbox_top;
	var _bb = bbox_bottom;
	// Restore original x/y values
	x = _prevx;
	y = _prevy;

	
	var _tmap = layer_tilemap_get_id(_layer);
	// Get cells at each bboxes (borders of tilemap rectangle to check)
	var _x1 = tilemap_get_cell_x_at_pixel(_tmap,_bl,_y),
		_x2 = tilemap_get_cell_x_at_pixel(_tmap,_br,_y),
		_y1 = tilemap_get_cell_y_at_pixel(_tmap,_x,_bt),
		_y2 = tilemap_get_cell_y_at_pixel(_tmap,_x,_bb);
	
	// Initialize _col as false
	var _col = false;
	// Loop through tile rectangle defined by coords and see if each tile is passable or not
	for (var _ix = _x1; _ix <= _x2; _ix +=1)
	{
		for (var _iy = _y1; _iy <= _y2; _iy +=1)
		{
			if (!tile_passable(_tmap,_ix,_iy))
			{
				// End loop if impassable tile is met
				var _col = true;
				return _col;
			}
		}
	}
	// Return if impassable place met or not
	return _col;

	#endregion
}

///@function	collision_rectangle_tile_impassable()
///@desc		Checks for collision with all "impassable" tiles on _layer and returns true if bounding box collides
///@param		x1
///@param		y1
///@param		x2
///@param		y2
///@param		layer
function collision_rectangle_tile_impassable(_x1,_y1,_x2,_y2,_layer){
	#region

	var _tmap = layer_tilemap_get_id(_layer);
	// Get cells at each bboxes (borders of tilemap rectangle to check)
	var _tx1 = tilemap_get_cell_x_at_pixel(_tmap,_x1,_y1),
		_tx2 = tilemap_get_cell_x_at_pixel(_tmap,_x2,_y1),
		_ty1 = tilemap_get_cell_y_at_pixel(_tmap,_x1,_y1),
		_ty2 = tilemap_get_cell_y_at_pixel(_tmap,_x1,_y2);
	
	// Initialize _col as false
	var _col = false;
	// Loop through tile rectangle defined by coords and see if each tile is passable or not
	for (var _ix = _tx1; _ix <= _tx2; _ix +=1)
	{
		for (var _iy = _ty1; _iy <= _ty2; _iy +=1)
		{
			if (!tile_passable(_tmap,_ix,_iy))
			{
				// End loop if impassable tile is met
				var _col = true;
				return _col;
			}
		}
	}
	// Return if impassable place met or not
	return _col;

	#endregion
}

///@func	collision_line_tile()
///@desc	Checks along a line for a given _tile or _tiles
///@param	_x1
///@param	_y1
///@param	_x2
///@param	_y2
///@param	_layer
///@param	_tile1
///@param	_tile2
///@param	_tile3
///@param	_tile4
///@param	_tile5
///@param	_tile6
function collision_line_tile(_x1,_y1,_x2,_y2,_layer,_tile1, _tile2 = undefined,
_tile3 = undefined, _tile4 = undefined, _tile5 = undefined, _tile6 = undefined){
	#region

	var _tilemap = layer_tilemap_get_id(_layer);
	// Dir of line
	var _dir = point_direction(_x1,_y1,_x2,_y2);
	var _dist = point_distance(_x1,_y1,_x2,_y2);
	// Get size of the tiles--used for size of checks along line
	var _size = tilemap_get_tile_width(_tilemap);
	// Loop through line
	for (var _i = 0; _i < _dist; _i += _size)
	{
		var _linex = _x1 + lengthdir_x(_i,_dir);
		var _liney = _y1 + lengthdir_y(_i,_dir);
		var _cellx = tilemap_get_cell_x_at_pixel(_tilemap,_linex,_liney);
		var _celly = tilemap_get_cell_y_at_pixel(_tilemap,_liney,_liney);
		
		if (tilemap_check_tile(_tilemap,_cellx,_celly,_tile1)) return true;
		else if (!is_undefined(_tile6)) && (tilemap_check_tile(_tilemap,_cellx,_celly,_tile2)) return true;
		else if (!is_undefined(_tile6)) && (tilemap_check_tile(_tilemap,_cellx,_celly,_tile3)) return true;
		else if (!is_undefined(_tile6)) && (tilemap_check_tile(_tilemap,_cellx,_celly,_tile4)) return true;
		else if (!is_undefined(_tile6)) && (tilemap_check_tile(_tilemap,_cellx,_celly,_tile5)) return true;
		else if (!is_undefined(_tile6)) && (tilemap_check_tile(_tilemap,_cellx,_celly,_tile6)) return true;
		
	}
	#endregion
}

///@func	collision_line_tile_impassable()
///@desc	Checks along a line for impassable tiles contained in layer. Requires tile_passable() function.
///@param	_x1
///@param	_y1
///@param	_x2
///@param	_y2
///@param	_layer
function collision_line_tile_impassable(_x1,_y1,_x2,_y2,_layer){
	#region
	var _tilemap = layer_tilemap_get_id(_layer);
	// Dir of line
	var _dir = point_direction(_x1,_y1,_x2,_y2);
	var _dist = point_distance(_x1,_y1,_x2,_y2);
	// Get size of the tiles--used for size of checks along line
	// _size is divided by 2 to reduce "corner cutting" on diagonal checks
	var _size = tilemap_get_tile_width(_tilemap)/2;
	// Loop through line
	for (var _i = 0; _i < _dist; _i += _size)
	{
		///////////////////////////////////
		// This code is bad. the length of the line is the same regardless of starting check point
		// This can lead to issues of thinking an entity is in a different tile than it is.
		// Keeping for future reference.
		//////////////////////////////////
		//if (_bboxcheck)
		//{
		//	#region optional all bbox check
		//	for (var _box = 0; _box < 4; _box += 1)
		//	{
		//		switch (_box)
		//		{
		//			case 0: var _linex = bbox_left + lengthdir_x(_i,_dir); var _liney = y + lengthdir_y(_i,_dir);
		//			break;
		//			case 1: var _linex = bbox_right + lengthdir_x(_i,_dir); var _liney = y + lengthdir_y(_i,_dir);
		//			break;
		//			case 2: var _linex = x + lengthdir_x(_i,_dir); var _liney = bbox_top + lengthdir_y(_i,_dir);
		//			break;
		//			case 3: var _linex = x + lengthdir_x(_i,_dir); var _liney = bbox_bottom + lengthdir_y(_i,_dir);
		//			break;
		//		}
		//		var _cellx = tilemap_get_cell_x_at_pixel(_tilemap,_linex,_liney);
		//		var _celly = tilemap_get_cell_y_at_pixel(_tilemap,_linex,_liney);
		//		if (!tile_passable(_tilemap,_cellx,_celly)) return true;
		//	}
		//	#endregion
		//}
		//else
		{
			#region Single point check
			var _linex = _x1 + lengthdir_x(_i,_dir);
			var _liney = _y1 + lengthdir_y(_i,_dir);
			var _cellx = tilemap_get_cell_x_at_pixel(_tilemap,_linex,_liney);
			var _celly = tilemap_get_cell_y_at_pixel(_tilemap,_linex,_liney);
	
			if (!tile_passable(_tilemap,_cellx,_celly)) return true;
			#endregion
		}	
	
	}
	#endregion
}

///@function	collision_points_tile()
///@desc		Checks for collision with _tile on _layer and returns true if _numpoints+ bbox are colliding
///@param		layer
///@param		tile
///@param		numpoints
function collision_points_tile(_layer,_tile,_numpoints = 4){
	#region
	var _tmap = layer_tilemap_get_id(_layer);

	// Set collision points and boxes to 0/false
	var _points = 0;
	// Check each point, adding up points and keeping track of which point touch
	var _tdata = tilemap_get_at_pixel(_tmap,bbox_left,y);
		var _tindex = tile_get_index(_tdata);
		if (_tindex == _tile) _points += 1;
	var _tdata = tilemap_get_at_pixel(_tmap,bbox_right,y);
		var _tindex = tile_get_index(_tdata);
		if (_tindex == _tile) _points += 1;
	var _tdata = tilemap_get_at_pixel(_tmap,x,bbox_top);
		var _tindex = tile_get_index(_tdata);
		if (_tindex == _tile) _points += 1;
	var _tdata = tilemap_get_at_pixel(_tmap,x,bbox_bottom);
		var _tindex = tile_get_index(_tdata);
		if (_tindex == _tile) _points += 1;

	// If more than 3 points touch, return true
	if (_points >= _numpoints)
	{
		return true;
	}
	else return false;
	#endregion
}

///@func	collision_raycast()
///@desc	Checks for collision using x,y in a given dir/dist. Returns shortest dist to collision or false		
function collision_raycast(_x,_y,_dir,_dist,_object){
	#region raycast
		var _coldist = noone; // initalize
		var _i = 0; // Pixel progress on collision check
		var _incr = 1; // initially check by large units
		for (var _i = 0; _i < _dist; _i += _incr)
		{
			var _xvec = lengthdir_x(_i,_dir);
			var _yvec = lengthdir_y(_i,_dir);
			var _col = collision_line(x,y,x+_xvec,y+_yvec,_object,false,true);

			if (_col != noone)
			{
				// If still checking by large incr, roll back and switch to small incr
				if (_incr != 1)
				{
					_i -= _incr;
					_incr = 1;
				}
				// Else save _i as distance to collision and end loop
				else
				{
					_coldist = _i;
					break;
				}
			}
		}
	
		return _coldist; // returns -4 or noone if no collision
	#endregion
}

///@func	collision_raycast_four()
///@desc	Checks for collision using bbox points in a given dir/dist. Returns shortest dist to collision or false		
function collision_raycast_four(_x,_y,_dir,_dist,_object){
	#region Ray cast Four
		var _coldist = noone; // initalize
		var _i = 0; // Pixel progress on collision check
		var _incr = 1; // initially check by large units
		for (var _i = 0; _i < _dist; _i += _incr)
		{
			var _xvec = lengthdir_x(_i,_dir);
			var _yvec = lengthdir_y(_i,_dir);
			//var _col = collision_line(x,y,x+_xvec,y+_yvec,_object,false,true);
		
			var _bl = collision_line(bbox_left,y,bbox_left+_xvec,y+_yvec,_object,false,true);
			var _br = collision_line(bbox_right,y,bbox_right+_xvec,y+_yvec,_object,false,true);
			var _bt = collision_line(x,bbox_top,x+_xvec,bbox_top+_yvec,_object,false,true);
			var _bb = collision_line(x,bbox_bottom,x+_xvec,bbox_bottom+_yvec,_object,false,true);
			if (_bl != noone) || (_br != noone) || (_bt != noone) || (_bb != noone)
			//if (_col != noone)
			{
				// If still checking by large incr, roll back and switch to small incr
				if (_incr != 1)
				{
					_i -= _incr;
					_incr = 1;
				}
				// Else save _i as distance to collision and end loop
				else
				{
					if (_bl != noone)
					{
						var _distadj = point_distance(x,y,bbox_left,y);
					}
					else if (_br != noone)
					{
						var _distadj = point_distance(x,y,bbox_right,y);
					}
					else if (_bt != noone)
					{
						var _distadj = point_distance(x,y,x,bbox_top);
					}
					else if (_bb != noone)
					{
						var _distadj = point_distance(x,y,x,bbox_bottom);
					}
					_coldist = _i + _distadj;
					break;
				}
			}
		}
	
		return _coldist; // returns -4 or noone if no collision
	#endregion
}