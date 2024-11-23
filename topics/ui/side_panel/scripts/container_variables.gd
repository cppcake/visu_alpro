class_name VarContainer extends MarginContainer

@export var variables_holder: VBoxContainer
func reset():
	for child in variables_holder.get_children():
		child.queue_free()

var variables: Array = []
func create_variable() -> Label:
	var label = Label.new()
	variables.append(label)
	variables_holder.add_child(label)
	return label
	
func create_variable_undo():
	var youngest_label = variables.pop_back()
	youngest_label.queue_free()
