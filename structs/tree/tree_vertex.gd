class_name tree_vertex_class extends list_vertex_class

var p2: pointer_class
var data: int
@export var sprite_visited: CompressedTexture2D

func _ready():
	super._ready()
	p2 = get_child(5)
	p2.current_end_point = global_position + Vector2(0, 150)
	p2.draw()
	p2.visible = true

func set_data(data_: int):
	data = data_
	label_data.text = str(data)
