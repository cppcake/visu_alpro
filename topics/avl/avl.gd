extends tree_traversal_class


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func aufgabe_01(argv: Array):
	create_tree(
		[16, 10, 25, 5, 12, 20, 3],
		[[0, 1, 0],
		[0, 2, 1],
		[1, 3, 0],
		[1, 4, 1],
		[2, 5, 0],
		[3, 6, 0]])
	
	push_operations([\
			Operation.new(
					Operation.opcodes.SET_POINTER_COLOR,
					[root_ptr, pointer_class.colors.ACCENT]),
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[root_ptr.target, list_vertex_class.sprites.ACCENT]),
	])
	
	push_operations([\
			Operation.new(
					Operation.opcodes.SET_POINTER_COLOR,
					[vertices[0].p1, pointer_class.colors.ACCENT]),
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[1], list_vertex_class.sprites.ACCENT]),
	])
	
	push_operations([\
			Operation.new(
					Operation.opcodes.SET_POINTER_COLOR,
					[vertices[1].p1, pointer_class.colors.ACCENT]),
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[3], list_vertex_class.sprites.ACCENT]),
	])
	
	push_operations([\
			Operation.new(
					Operation.opcodes.SET_POINTER_COLOR,
					[vertices[3].p1, pointer_class.colors.ACCENT]),
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[6], list_vertex_class.sprites.ACCENT]),
	])
	
	push_operations([\
			Operation.new(
					Operation.opcodes.SET_POINTER_COLOR,
					[vertices[6].p2, pointer_class.colors.ACCENT]),
	])
	
	var vertex = vertex_scene.instantiate()
	vertex.visible = false
	vertex.set_data(4)
	add_child(vertex)
	vertex.global_position = Vector2(-1000, 650)
	push_operations([
			Operation.new(
					Operation.opcodes.TOGGLE_VISIBLE,
					[vertex]),
			Operation.new(
					Operation.opcodes.POINT_AT,
					[vertices[6].p2, vertex]),
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertex, list_vertex_class.sprites.ACCENT]),
	])
	
	push_operations([
			Operation.new(
					Operation.opcodes.SET_TAG,
					[vertices[6], "1"]),
	])
	
	push_operations([
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[6], list_vertex_class.sprites.ACCENT_2]),
	])
	
	push_operations([
			Operation.new(
					Operation.opcodes.SET_TAG,
					[vertices[3], "-2"]),
	])
	
	push_operations([
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[3], list_vertex_class.sprites.TO_REMOVE]),
	])
	
	push_operations([
			Operation.new(
					Operation.opcodes.POINT_AT,
					[vertex.p1, vertices[6]]),
	])
	
	push_operations([
			Operation.new(
					Operation.opcodes.POINT_AT,
					[vertex.p1, vertices[6]]),
			Operation.new(
					Operation.opcodes.POINT_AT,
					[vertex.p2, vertices[3]]),
	])

var vertices: Array = []
func create_tree(data_array: Array, edge_array: Array):
	for vertex in vertices:
		vertex.queue_free()
	vertices.clear()
	
	for data in data_array:
		var vertex = vertex_scene.instantiate()
		vertex.set_data(data)
		vertices.push_back(vertex)
		add_child(vertex)
	
	for edge in edge_array:
		match edge[2]:
			0:
				vertices[edge[0]].p1.set_target(vertices[edge[1]])
			1:
				vertices[edge[0]].p2.set_target(vertices[edge[1]])
	
	root_ptr.set_target(vertices[0])
	reposition()

func parent(index):
	return int((index - 1) / 2)

func _on_buton_aufgabe_01_pressed():
	init_algo(aufgabe_01, [])
