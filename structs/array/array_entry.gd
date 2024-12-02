extends VBoxContainer

@export var label_data: Label
@export var label_index: Label

func set_label_data(text_):
	label_data.text = text_
	
func set_label_index(index):
	label_index.text = str(index)
