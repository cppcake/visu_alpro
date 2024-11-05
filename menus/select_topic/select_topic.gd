extends ItemList




func _on_item_selected(index):
	match index:
		0:
			get_tree().call_deferred("change_scene_to_file", "res://algorithms/graph_traversal/graph_traversal.tscn")
