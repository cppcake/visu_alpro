extends Control

@export var controller: Node

func _on_button_vertices_pressed():
	controller.set_mode(controller.modes.vertices)

func _on_button_edges_pressed():
	controller.set_mode(controller.modes.edges)
	
func _on_button_move_pressed():
	controller.set_mode(controller.modes.move)

func _on_button_bfs_pressed():
	controller.set_mode(controller.modes.bfs)

func _on_button_dfs_pressed():
	controller.set_mode(controller.modes.dfs)
