class_name tree_traversal_class extends operator_class

@export var root_ptr: pointer_class

func _ready():
	init_algo(insert, [7, root_ptr])
	finish()
	init_algo(insert, [5, root_ptr])
	finish()
	init_algo(insert, [9, root_ptr])
	finish()
	init_algo(insert, [4, root_ptr])
	finish()
	#init_algo(insert, [6, root_ptr])
	#finish()
	#init_algo(insert, [8, root_ptr])
	#finish()
	#init_algo(insert, [10, root_ptr])
	#finish()

var offset_y: int = 180
var min_offset_x: int = 80
func reposition():
	var width: int = int(pow(2, calculate_height(root_ptr))) * min_offset_x
	reposition_(root_ptr, width)
func reposition_(root: pointer_class, width: int):
	var root_vertex = root.target
	if root_vertex == null:
		return
	if root_vertex.dest_pos == null:
		root_vertex.dest_pos = root_vertex.global_position
	
	var left_child = root_vertex.p1.target
	if left_child != null:
		left_child.move_to(root_vertex.dest_pos + Vector2(-width, offset_y))
		reposition_(root_vertex.p1, width / 2)
	
	var right_child = root_vertex.p2.target
	if right_child != null:
		right_child.move_to(root_vertex.dest_pos + Vector2(+width, offset_y))
		reposition_(root_vertex.p2, width / 2)
func calculate_height(root: pointer_class) -> int:
	var root_vertex = root.target
	if root_vertex == null:
		return -1
	var height = 0
	
	var left_child = root_vertex.p1.target
	var left_height: int = 0
	if left_child != null:
		left_height = calculate_height(root_vertex.p1) + 1
	
	var right_child = root_vertex.p2.target
	var right_height: int = 0
	if right_child != null:
		right_height = calculate_height(root_vertex.p2) + 1
	
	if left_height > right_height:
		return height + left_height
	else:
		return height + right_height

func insert(argv: Array):
	var data = argv[0]
	var ptr = argv[1]
	var root = ptr.target
	
	if argv.size() > 2:
		var ptr_be = argv[1]
		push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[1]])
		,Operation.new(\
			Operation.opcodes.SET_POINTER_COLOR,\
			[ptr, pointer_class.colors.ACCENT_2])\
		])
	
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[1]])
		,Operation.new(\
			Operation.opcodes.SET_POINTER_COLOR,\
			[ptr, pointer_class.colors.ACCENT_2])
	])
	if root == null:
		new_vertex = create_new_vertex(ptr.current_end_point + Vector2(0, 100), "right")
		new_vertex.set_data(data)
		
		push_operations([\
			Operation.new(\
				Operation.opcodes.MAKE_SHARED,\
				[new_vertex])\
			,Operation.new(\
				Operation.opcodes.POINT_AT,\
				[ptr, new_vertex])\
			,Operation.new(\
				Operation.opcodes.SET_SPRITE,\
				[new_vertex, list_vertex_class.sprites.ACCENT])\
			,Operation.new(\
				Operation.opcodes.HIGHLIGHT_CODE,\
				[[2]])
		])
		
		push_operations([\
			Operation.new(\
				Operation.opcodes.HIGHLIGHT_CODE,\
				[[3]])
		])
		return

	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[6]])
	])
	if root.data > data:
		push_operations([\
			Operation.new(\
				Operation.opcodes.HIGHLIGHT_CODE,\
				[[7]])
			,Operation.new(\
				Operation.opcodes.SET_POINTER_COLOR,\
				[ptr, pointer_class.colors.ACCENT])
		])
		insert([data, root.p1])
	else:
		push_operations([\
			Operation.new(\
				Operation.opcodes.HIGHLIGHT_CODE,\
				[[8]])
		])
		
		push_operations([\
			Operation.new(\
				Operation.opcodes.HIGHLIGHT_CODE,\
				[[9]])
			,Operation.new(\
				Operation.opcodes.SET_POINTER_COLOR,\
				[ptr, pointer_class.colors.ACCENT])
		])
		insert([data, root.p2])
func _on_button_insert_pressed():
	side_panel.override_code(tr("INS_BST"))
	
	var randiii: int = randi() % 100
	side_panel.override_code_call("bst.insert(root_ptr, " + str(randiii) + ")")
	init_algo(insert, [randiii, root_ptr])

func inorder(argv: Array) -> Array:
	var ptr: pointer_class = argv[0]
	var root = ptr.target

	if root != null:
		push_operations([\
			Operation.new(\
				Operation.opcodes.SET_POINTER_COLOR,\
				[ptr, pointer_class.colors.ACCENT_2])\
			,Operation.new(\
				Operation.opcodes.SET_SPRITE,\
				[root, list_vertex_class.sprites.ACCENT])\
			,Operation.new(\
				Operation.opcodes.HIGHLIGHT_CODE,\
				[[1]])
			,Operation.new(\
				Operation.opcodes.CALL,\
				["inorder"])
			,Operation.new(\
				Operation.opcodes.OVERWRITE_VARIABLE,\
				[0, "F  = []"])
			,Operation.new(\
				Operation.opcodes.OVERWRITE_VARIABLE,\
				[1, "F_left  = []"])
			,Operation.new(\
				Operation.opcodes.OVERWRITE_VARIABLE,\
				[2, "F_right  = []"])
			])
	else:
		push_operations([\
			Operation.new(\
				Operation.opcodes.HIGHLIGHT_CODE,\
				[[1]])
			,Operation.new(\
				Operation.opcodes.SET_POINTER_COLOR,\
				[ptr, pointer_class.colors.ACCENT_2])\
			,Operation.new(\
				Operation.opcodes.CALL,\
				["inorder"])
			])
	var array = []
	var left_array = []
	var right_array = []

	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[3]])
		,
		])
	if root == null:
		push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[4]])
		,
		])
		return array

	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[6]])
		,Operation.new(\
			Operation.opcodes.SET_POINTER_COLOR,\
			[root.p1, pointer_class.colors.ACCENT_2])\
		])
	left_array = inorder([root.p1])
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[7]])
		,Operation.new(\
			Operation.opcodes.RETURN,\
			[])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[1, "F_left = " + str(left_array)])
		])
	
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[7]])
		,Operation.new(\
			Operation.opcodes.SET_POINTER_COLOR,\
			[root.p2, pointer_class.colors.ACCENT_2])\
		])
	right_array = inorder([root.p2])
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[9]])
		,Operation.new(\
			Operation.opcodes.RETURN,\
			[])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[2, "F_right = " + str(right_array)])
		])


	array.append_array(left_array)
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[9]])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[0, "F  = " + str(array)])
		])
	
	array.append(root.data)
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[10]])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[0, "F  = " + str(array)])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[1, "F_left = " + str(left_array)])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[2, "F_right = " + str(right_array)])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[0, "F  = " + str(array)])
		])
	
	array.append_array(right_array)
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[11]])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[0, "F  = " + str(array)])
		])

	if ptr == root_ptr:
		push_operations([\
			Operation.new(\
				Operation.opcodes.HIGHLIGHT_CODE,\
				[[13]])
			,Operation.new(\
				Operation.opcodes.RETURN,\
				[])
			])
	else:
			push_operations([\
			Operation.new(\
				Operation.opcodes.HIGHLIGHT_CODE,\
				[[13]])
			,
			])
	return array
func _on_button_inorder_pressed():
	side_panel.create_variable()
	side_panel.create_variable()
	side_panel.create_variable()
	side_panel.select_containers(1, 1, 1, 0)
	side_panel.override_code(tr("INORDER"))
	side_panel.override_code_call("inorder(tree_node)")
	side_panel.open()

	init_algo(inorder, [root_ptr])
