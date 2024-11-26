class_name VarContainer extends MarginContainer

@onready var variable_scene = preload("res://topics/ui/scenes/variable.tscn")

@export var variables_holder: VBoxContainer
func reset():
	for child in variables_holder.get_children():
		child.queue_free()
	custom_minimum_size = Vector2(0, 0)
	variables.clear()

var variables: Array = []
func create_variable() -> Label:
	var label = variable_scene.instantiate()
	variables.append(label)
	variables_holder.add_child(label)
	custom_minimum_size += Vector2(0, 60)
	return label
func create_variable_undo():
	var youngest_label = variables.pop_back()
	youngest_label.queue_free()
	custom_minimum_size -= Vector2(0, 60)

func overwrite_variable(index: int, text_: String):
	variables[index].overwrite(text_)
func overwrite_variable_undo(index: int):
	variables[index].overwrite_undo()
