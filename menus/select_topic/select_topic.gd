extends ItemList

func _process(_delta):
	var window_size = get_viewport().get_visible_rect().size
	var columns = floor(window_size[0] / 420)
	if columns < 1:
		columns = 1
	max_columns = columns
	custom_minimum_size = Vector2(columns * 420, 0)

func _on_item_selected(index):
	var scene_man = scene_manager.new()
	add_child(scene_man)
	match index:
		0:
			scene_man.change_scene("graph_traversal")
		1:
			scene_man.change_scene("simple_list")
