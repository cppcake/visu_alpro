class_name stackframe extends Control

@export var label: Label
@export var variables_holder: VBoxContainer

func _ready():
	label.text = "TEXTTTT"

var variables: Array = []
func create_variable(variable_name: String):
	var variable = Label.new()
	variable.text = variable_name
	variables.append(variable)
	variables_holder.add_child(variable)
func create_variable_undo():
	var variable = variables.pop_back()
	variable.queue_free()
