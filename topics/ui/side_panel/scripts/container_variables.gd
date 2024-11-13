class_name VarContainer extends MarginContainer

@export var variables: VBoxContainer
func reset():
	for child in variables.get_children():
		child.queue_free()

func create_variable() -> Label:
	# Create a new Label instance
	var label = Label.new()
	# Add the label as a child of the current node
	variables.add_child(label)
	return label
