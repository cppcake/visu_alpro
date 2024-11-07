extends Button

@export var controller: Node

# How big the jump is
@export var jump: int

func _on_pressed():
	controller.proceed_algorithm(jump)
