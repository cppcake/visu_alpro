class_name tree_vertex_class extends list_vertex_class

var p2: pointer_class
@export var sprite_visited: CompressedTexture2D

func _ready():
	super._ready()
	p2 = get_child(5)
	p2.current_end_point = global_position + Vector2(0, 150)
	p2.draw()
	p2.visible = true
	data_history.push_back(data)

var data_history: Array = []
func set_data(data_: int, save: bool = true):
	if save:
		data_history.push_back(data_history)
	data = data_
	label_data.text = str(data)
func set_data_undo():
	data_history.pop_back()
	set_data(data_history.back(), false)
