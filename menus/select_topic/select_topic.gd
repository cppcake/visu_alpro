extends GridContainer

func _process(_delta):
	var window_size = get_viewport().get_visible_rect().size
	var max_columns = floor(window_size[0] / (450 + 12))
	if max_columns < 1:
		max_columns = 1
	columns = max_columns
	custom_minimum_size = Vector2(columns * 450, 0)
