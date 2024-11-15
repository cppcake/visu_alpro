class_name doubly_list_vertex_class extends list_vertex_class

var p2: weak_pointer_class

func _ready():
	super._ready()
	p2 = get_child(5)
	p2.current_end_point = global_position + Vector2(0, 150)
	p2.draw()
	p2.visible = true
	
