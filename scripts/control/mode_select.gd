extends Control

@export var controller: Node

func _on_button_knoten_pressed():
	controller.set_mode(controller.modes.vertices)

func _on_button_kanten_pressed():
	controller.set_mode(controller.modes.edges)
	
func _on_button_auswahl_pressed():
	controller.set_mode(controller.modes.move)

func _on_button_breitensuche_pressed():
	controller.set_mode(controller.modes.bfs)

func _on_button_tiefensuche_pressed():
	controller.set_mode(controller.modes.dfs)
