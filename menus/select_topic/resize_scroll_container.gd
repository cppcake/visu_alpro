extends Control

func _process(_delta):
	var window_size = get_viewport().get_visible_rect().size
	var columns = floor(window_size[0]) /(450  + 16)
	if columns < 1:
		columns = 1
		
	custom_minimum_size = Vector2(columns * (450  + 16), window_size[1] - 400 * (window_size[1] / 1080))
	
