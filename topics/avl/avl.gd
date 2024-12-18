extends tree_traversal_class

@export var kalm: Sprite2D
@export var wait: Sprite2D
@export var always: Sprite2D

func _ready():
	pass

func clean_up():
	super.clean_up()
	kalm.visible = false
	wait.visible = false
	always.visible = false

var vertices: Array = []
func create_tree(data_array: Array, edge_array: Array):
	get_tree().call_group("vertices", "queue_free")
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
	reposition()

func parent(index):
	return int((index - 1) / 2)

func aufgabe_01(argv: Array):
	new_vertex = vertex_scene.instantiate()
	new_vertex.visible = false
	new_vertex.set_data(4)
	new_vertex.global_position = vertices[6].dest_pos + Vector2(100, 100)
	new_vertex.move_to(new_vertex.global_position)
	new_vertex.set_coef(0)
	add_child(new_vertex)
	
	push_operations([
			Operation.new(
					Operation.opcodes.POINT_AT,
					[vertices[6].p2, new_vertex]),
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[new_vertex, list_vertex_class.sprites.ACCENT_2]),
			Operation.new(
					Operation.opcodes.TOGGLE_VISIBLE,
					[new_vertex]),
			Operation.new(
					Operation.opcodes.COEFS,
					[vertices, [-2, -2, -1 , -2, 0, 0, 1]]),
	])
	
	push_operations([
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[3], list_vertex_class.sprites.TO_REMOVE]),
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[6], list_vertex_class.sprites.ACCENT]),
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
					[new_vertex, vertices[3].dest_pos + Vector2(-150, 150)]),
			Operation.new(
					Operation.opcodes.MOVE,
					[vertices[6], vertices[3].dest_pos + Vector2(-300, 300)]),
			Operation.new(
					Operation.opcodes.COEFS,
					[[new_vertex], [-1]]),
			Operation.new(
					Operation.opcodes.COEFS,
					[[vertices[6]], [0]]),
	])
	
	push_operations([
			Operation.new(
					Operation.opcodes.POINT_AT,
					[vertices[1].p1, new_vertex]),
			Operation.new(
					Operation.opcodes.REPOS,
						[[]]),
			Operation.new(
					Operation.opcodes.TOGGLE_VISIBLE,
					[kalm]),
			Operation.new(
					Operation.opcodes.COEFS,
					[vertices, [-1, -1, -1 , 0, 0, 0, 0]]),
			Operation.new(
					Operation.opcodes.COEFS,
					[[new_vertex], [0]]),
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[3], list_vertex_class.sprites.DEFAULT]),
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[6], list_vertex_class.sprites.DEFAULT]),
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[new_vertex, list_vertex_class.sprites.DEFAULT]),
	])
func _on_buton_aufgabe_01_pressed():
	offset_y= 150
	min_offset_x = 50
	mult = 2
	create_tree(
		[16, 10, 25, 5, 12, 20, 3],
		[[0, 1, 0],
		[0, 2, 1],
		[1, 3, 0],
		[1, 4, 1],
		[2, 5, 0],
		[3, 6, 0]])
	
	var coefs = [-1, -1, -1, -1, 0, 0, 0]
	for i in range(vertices.size()):
		vertices[i].set_coef(coefs[i])
	
	init_algo(aufgabe_01)

func aufgabe_02(argv: Array):
	push_operations([
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[2], list_vertex_class.sprites.TO_REMOVE]),
	])
	
	push_operations([
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[5], list_vertex_class.sprites.ACCENT]),
	])
	
	push_operations([
			Operation.new(
					Operation.opcodes.SWAP,
					[vertices[2], vertices[5]]),
	])

	push_operations([
		Operation.new(
					Operation.opcodes.POINT_AT,
					[vertices[2].p2, null]),
			Operation.new(
					Operation.opcodes.TOGGLE_VISIBLE,
					[vertices[5]]),
			Operation.new(
					Operation.opcodes.COEFS,
					[[vertices[0], vertices[2]], [-2, 0]]),
	])
	
	push_operations([
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[2], list_vertex_class.sprites.DEFAULT]),
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[0], list_vertex_class.sprites.TO_REMOVE]),
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[1], list_vertex_class.sprites.ACCENT]),
	])

	
	## SECOND PHASE
	
	push_operations([
			Operation.new(
					Operation.opcodes.POINT_AT,
					[vertices[1].p2, vertices[0]]),
			Operation.new(
					Operation.opcodes.POINT_AT,
					[vertices[0].p1, vertices[4]]),
			Operation.new(
					Operation.opcodes.COEFS,
					[vertices, [0, 0, 0, 1, 0, 0, 0]]),
	])

	push_operations([
			Operation.new(
					Operation.opcodes.POINT_AT,
					[root_ptr, vertices[1]]),
			Operation.new(
					Operation.opcodes.REPOS,
					[]),
			Operation.new(
					Operation.opcodes.TOGGLE_VISIBLE,
					[kalm]),
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[0], list_vertex_class.sprites.DEFAULT]),
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[1], list_vertex_class.sprites.DEFAULT]),
	])
func _on_buton_aufgabe_02_pressed():
	offset_y= 150
	min_offset_x = 50
	mult = 2
	create_tree(
		[16, 10, 25, 5, 12, 30, 6],
		[[0, 1, 0],
		[0, 2, 1],
		[1, 3, 0],
		[1, 4, 1],
		[2, 5, 1],
		[3, 6, 1]])
	
	var coefs = [-1, -1, 1, 1, 0, 0, 0]
	for i in range(vertices.size()):
		vertices[i].set_coef(coefs[i])
	
	init_algo(aufgabe_02)


func aufgabe_03(argv: Array):
	push_operations([
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[4], list_vertex_class.sprites.TO_REMOVE]),
	])
	
	push_operations([
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[14], list_vertex_class.sprites.ACCENT]),
	])

	push_operations([
			Operation.new(
					Operation.opcodes.SWAP,
					[vertices[4], vertices[14]]),
	])
	
	push_operations([
		Operation.new(
					Operation.opcodes.POINT_AT,
					[vertices[9].p1, null]),
			Operation.new(
					Operation.opcodes.TOGGLE_VISIBLE,
					[vertices[14]]),
			Operation.new(
					Operation.opcodes.COEFS,
					[[vertices[9]], [1]]),
	])
	
	push_operations([
			Operation.new(
					Operation.opcodes.TOGGLE_VISIBLE,
					[wait]),
			Operation.new(
					Operation.opcodes.SET_SPRITE,
					[vertices[4], list_vertex_class.sprites.DEFAULT]),
	])
	
	push_operations([
			Operation.new(
					Operation.opcodes.TOGGLE_VISIBLE,
					[always]),
	])
func _on_buton_aufgabe_03_pressed():
	offset_y= 100
	min_offset_x = 15
	mult = 2
	create_tree(
		[9, 3, 15, 2, 5, 13, 20, 1, 4, 7, 11, 14, 18, 21, 6, 8, 10, 12, 17, 19, 22, 16],
		[[0, 1, 0],
		[0, 2, 1],
		[1, 3, 0],
		[1, 4, 1],
		[2, 5, 0],
		[2, 6, 1],
		[3, 7, 0],
		[4, 8, 0],
		[4, 9, 1],
		[5, 10, 0],
		[5, 11, 1],
		[6, 12, 0],
		[6, 13, 1],
		[9, 14, 0],
		[9, 15, 1],
		[10, 16, 0],
		[10, 17, 1],
		[12, 18, 0],
		[12, 19, 1],
		[13, 20, 1],
		[18, 21, 0]])
	
	for vertex in vertices:
		var left = calculate_height(vertex.p1)
		var right = calculate_height(vertex.p2)
		vertex.set_coef(right - left)
	
	init_algo(aufgabe_03)
