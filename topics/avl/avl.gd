extends tree_traversal_class

func _ready():
	pass

var vertices: Array = []
func create_tree(data_array: Array, edge_array: Array):
	if is_instance_valid(new_vertex):
		new_vertex.queue_free()
	
	for vertex in vertices:
		vertex.queue_free()
	vertices.clear()
	
	for data in data_array:
		var vertex = vertex_scene.instantiate()
		vertex.set_data(data)
		vertex.visible = false
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

func aufgabe_01(argv: Array):
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
	
	new_vertex = vertex_scene.instantiate()
	new_vertex.visible = false
	new_vertex.set_data(4)
	add_child(new_vertex)
	new_vertex.global_position = vertices[6].global_position + Vector2(100, 100)
	push_operations([
			Operation.new(
					Operation.opcodes.TOGGLE_VISIBLE,
					[new_vertex]),
			Operation.new(
					Operation.opcodes.POINT_AT,
					[vertices[6].p2, new_vertex]),
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[new_vertex, list_vertex_class.sprites.ACCENT]),
	])
	
	push_operations([
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[6], list_vertex_class.sprites.ACCENT_2]),
	])
	
	push_operations([
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[3], list_vertex_class.sprites.TO_REMOVE]),
	])
	
	push_operations([
			Operation.new(
					Operation.opcodes.POINT_AT,
					[vertices[3].p1, null]),
			Operation.new(
					Operation.opcodes.POINT_AT,
					[vertices[6].p2, null]),
			Operation.new(
					Operation.opcodes.POINT_AT,
					[new_vertex.p1, vertices[6]]),
			Operation.new(
					Operation.opcodes.POINT_AT,
					[new_vertex.p2, vertices[3]]),
			Operation.new(
					Operation.opcodes.MOVE,
					[new_vertex, vertices[3].global_position + Vector2(-150, 150)]),
			Operation.new(
					Operation.opcodes.MOVE,
					[vertices[6], vertices[3].global_position + Vector2(-300, 300)]),
	])
	
	push_operations([
			Operation.new(
					Operation.opcodes.POINT_AT,
					[vertices[1].p1, new_vertex]),
			Operation.new(
					Operation.opcodes.MOVE,
					[vertices[3],  Vector2(vertices[3].global_position.x, vertices[3].global_position.y + 300)]),
	])
func _on_buton_aufgabe_01_pressed():
	root_ptr.visible = false
	create_tree(
		[16, 10, 25, 5, 12, 20, 3],
		[[0, 1, 0],
		[0, 2, 1],
		[1, 3, 0],
		[1, 4, 1],
		[2, 5, 0],
		[3, 6, 0]])
	
	await get_tree().create_timer(1).timeout
	
	await call_deferred("init_algo", aufgabe_01, [])
	
	for vertex in vertices:
		vertex.visible = true
	root_ptr.visible = true
