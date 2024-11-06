extends ItemList

func _process(_delta):
	var window_size = get_viewport().get_visible_rect().size
	var columns = floor(window_size[0] / 420)
	if columns < 1:
		columns = 1
	max_columns = columns
	custom_minimum_size = Vector2(columns * 420, 0)

func _on_item_selected(index):
	match index:
		0:
			get_tree().call_deferred("change_scene_to_file", "res://algorithms/graph_traversal/graph_traversal.tscn")
