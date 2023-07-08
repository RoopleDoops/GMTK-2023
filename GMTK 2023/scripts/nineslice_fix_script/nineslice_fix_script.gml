///@function	nineslice_mask_correct()
///@desc		Corrects the collision mask of an object using nineslice scaling
///@param		_sprite	
///@param		_wadjust
///@param		_hadjust

function nineslice_mask_correct(_sprite = sprite_index, _wadjust = undefined, _hadjust = undefined){
	#region
	draw_scalex = image_xscale; // Use to draw object at appropriate size
	draw_scaley = image_yscale; // Use to draw object at appropriate size
	
	var _mask_height = (sprite_get_bbox_bottom(_sprite)+1) - sprite_get_bbox_top(_sprite);
	var _mask_width = (sprite_get_bbox_right(_sprite)+1) - sprite_get_bbox_left(_sprite);
		
	if (is_undefined(_wadjust))
	{
		_wadjust = sprite_get_width(_sprite) - _mask_width;
	}
	
	if (is_undefined(_hadjust))
	{
		_hadjust = sprite_get_height(_sprite) - _mask_height;
	}
			
	image_xscale = (sprite_width - _wadjust)/_mask_width; // Use to draw HITBOX at appropriate size
	image_yscale = (sprite_height - _hadjust)/_mask_height; // Use to draw HITBOX at appropriate size
	#endregion
}