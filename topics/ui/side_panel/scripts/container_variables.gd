class_name VarContainer extends MarginContainer

@export var variables_holder: VBoxContainer
func reset():
	for child in variables_holder.get_children():
		child.queue_free()
	custom_minimum_size = Vector2(0, 0)

var variables: Array = []
func create_variable() -> Label:
	var label = Label.new()
	variables.append(label)
	variables_holder.add_child(label)
	custom_minimum_size += Vector2(0, 60)
	return label
func create_variable_undo():
	var youngest_label = variables.pop_back()
	youngest_label.queue_free()
	custom_minimum_size -= Vector2(0, 60)
