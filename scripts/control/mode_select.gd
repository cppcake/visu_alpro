extends Control

var statemachine: Node
@export var controller: Node

func _on_button_knoten_pressed():
	controller.set_mode(0)

func _on_button_kanten_pressed():
	controller.set_mode(1)
	
func _on_button_auswahl_pressed():
	controller.set_mode(2)

func _on_button_breitensuche_pressed():
	controller.set_mode(3)

func _on_button_tiefensuche_pressed():
	controller.set_mode(4)
