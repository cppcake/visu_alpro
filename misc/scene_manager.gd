class_name scene_manager extends Node

var select_locale_path = "res://menus/select_locale/select_locale.tscn"
var select_topic_path = "res://menus/select_topic/select_topic.tscn"
var graph_traversal_path = "res://algorithms/graph_traversal/graph_traversal.tscn"

func change_scene(scene: String):
	match scene:
		"select_locale":
			get_tree().call_deferred("change_scene_to_file", select_locale_path)
		"select_topic":
			get_tree().call_deferred("change_scene_to_file", select_topic_path)
		"graph_traversal":
			get_tree().call_deferred("change_scene_to_file", graph_traversal_path)
