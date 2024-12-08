extends VBoxContainer

@export var label_data: Label
@export var label_index: Label

func set_label_data(text_):
	label_data.text = text_
	
func set_label_index(index):
	label_index.text = str(index)

func set_color(color: list_vertex_class.sprites):
	match color:
		list_vertex_class.sprites.DEFAULT:
			modulate = Color.WHITE
		list_vertex_class.sprites.ACCENT:
			modulate = Color.BLUE_VIOLET
		list_vertex_class.sprites.ACCENT_2:
			modulate = Color.CHARTREUSE
		list_vertex_class.sprites.TO_REMOVE:
			modulate = Color.RED
