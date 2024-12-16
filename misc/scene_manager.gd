class_name scene_manager extends Node

func change_scene(scene: String):
	get_node("/root/OptionsMenu/options_menu").visible = false
	get_node("/root/OptionsMenu/options_menu/Panel/VBoxContainer/select_locale/OptionButton").selected = 2
	
	match scene:
		"select_locale":
			get_tree().call_deferred("change_scene_to_file", "res://menus/select_locale/select_locale.tscn")
		"select_topic":
			get_tree().call_deferred("change_scene_to_file", "res://menus/select_topic/select_topic.tscn")
		"graph_traversal":
			get_tree().call_deferred("change_scene_to_file", "res://topics/graph_traversal/graph_traversal.tscn")
		"simple_list":
			get_tree().call_deferred("change_scene_to_file", "res://topics/simple_list/simple_list.tscn")
		"doubly_list":
			get_tree().call_deferred("change_scene_to_file", "res://topics/doubly_list/doubly_list.tscn")
		"tree_traversal":
			get_tree().call_deferred("change_scene_to_file", "res://topics/tree_traversal/tree_traversal.tscn")
		"max_heap":
			get_tree().call_deferred("change_scene_to_file", "res://topics/max_heap/max_heap.tscn")
		"avl":
			get_tree().call_deferred("change_scene_to_file", "res://topics/avl/avl.tscn")
