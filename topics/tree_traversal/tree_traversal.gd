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
	init_algo(insert, [6, root_ptr])
	finish()
	init_algo(insert, [8, root_ptr])
	finish()
	init_algo(insert, [10, root_ptr])
	finish()

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
func calculate_pointer_names():
	root_ptr.pointer_name = "root"
	
	if root_ptr.target != null:
		calculate_pointer_names_(root_ptr.target.p1, "root->left")
		calculate_pointer_names_(root_ptr.target.p2, "root->right")
func calculate_pointer_names_(root: pointer_class, root_name: String):
	root.pointer_name = root_name
	
	if root.target != null:
		calculate_pointer_names_(root.target.p1, root_name + "->left")
		calculate_pointer_names_(root.target.p2, root_name + "->right")
func clean_up():
	super.clean_up()
	calculate_pointer_names()

func insert(argv: Array):
	var data = argv[0]
	var ptr = argv[1]
	var ptr_target = ptr.target

	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[1]])
		,Operation.new(\
			Operation.opcodes.SET_POINTER_COLOR,\
			[ptr, pointer_class.colors.ACCENT_2])
	])
	if ptr_target == null:
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

	# Highlight first recursiv call
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[6]])
	])
	if ptr_target.data > data:
		push_operations([\
			Operation.new(\
				Operation.opcodes.HIGHLIGHT_CODE,\
				[[7]])
			,Operation.new(\
				Operation.opcodes.SET_POINTER_COLOR,\
				[ptr, pointer_class.colors.ACCENT])
		])
		insert([data, ptr_target.p1])
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
		insert([data, ptr_target.p2])
func _on_button_insert_pressed():
	side_panel.override_code(tr("INS_BST"))
	side_panel.select_containers(1, 0, 0, 0)
	var randiii: int = randi() % 100
	side_panel.override_code_call("bst.insert(root_ptr, " + str(randiii) + ")")
	init_algo(insert, [randiii, root_ptr])
	side_panel.open()

func inorder(argv: Array) -> Array:
	var ptr: pointer_class = argv[0]
	var ptr_target = ptr.target
	var ptr_name = ptr.pointer_name
	
	# Push stackframe of call
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[]])
		,Operation.new(\
			Operation.opcodes.SET_POINTER_COLOR,\
			[ptr, pointer_class.colors.ACCENT])\
		,Operation.new(\
			Operation.opcodes.SET_SPRITE,\
			[ptr_target, list_vertex_class.sprites.ACCENT])\
		,Operation.new(\
			Operation.opcodes.OVERWRITE_CALL,\
			["inorder(start_ptr = " + ptr_name + ")"])\
		,Operation.new(\
			Operation.opcodes.CALL,\
			["CALL"])\
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[0, ""])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[1, ""])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[2, ""])
		])
	
	# Abbruchbedingung check. Markiere current_ptr und if_statement
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[1]])
		])
	if ptr_target == null:
		# Abdruchbedingung greift. Return empty Array.
		push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[2]])
		,Operation.new(\
			Operation.opcodes.RETURN,\
			[[]])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_RETURN,\
			[[]])
		])
		return []
	
	# Create sequences
	var F = []
	var F_left = []
	var F_right = []
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[4]])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[0, "F = " + str(F)])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[1, "F_left = " + str(F_left)])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[2, "F_right = " + str(F_right)])
		])

	# First recursiv call into the left subtree
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[6]])
		])
	F_left = inorder([ptr_target.p1])
	var last_pop_left = side_panel.get_last_pop()
	push_operations([\
		Operation.new(\
			Operation.opcodes.OVERWRITE_RETURN,\
			[39])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_CALL,\
			["inorder(start_ptr = " + ptr_name + ")"])\
		,Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[6]])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[0, "F = " + str(F)])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[1, "F_left = " + str(F_left) + " (" + tr("RETURN_VALUE_OF") + " " + tr("CALL") + " " + str(last_pop_left) + ")"])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[2, "F_right = " + str(F_right)])
		])

	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[7]])
		,
		])
	F_right = inorder([ptr_target.p2])
	var last_pop_right = side_panel.get_last_pop()
	push_operations([\
		Operation.new(\
			Operation.opcodes.OVERWRITE_RETURN,\
			[39])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_CALL,\
			["inorder(start_ptr = " + ptr_name + ")"])\
		,Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[7]])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[0, "F = " + str(F)])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[1, "F_left = " + str(F_left) + " (" + tr("RETURN_VALUE_OF") + " " + tr("CALL") + " " + str(last_pop_left) + ")"])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[2, "F_right = " + str(F_right) + " (" + tr("RETURN_VALUE_OF") + " " + tr("CALL") + " " + str(last_pop_right) + ")"])
		])

	F.append_array(F_left)
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[9]])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[0, "F = " + str(F)])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[1, "F_left = " + str(F_left) + " (" + tr("RETURN_VALUE_OF") + " " + tr("CALL") + " " + str(last_pop_left) + ")"])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[2, "F_right = " + str(F_right) + " (" + tr("RETURN_VALUE_OF") + " " + tr("CALL") + " " + str(last_pop_right) + ")"])
		])
	
	F.append(ptr_target.data)
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[10]])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[0, "F = " + str(F)])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[1, "F_left = " + str(F_left) + " (" + tr("RETURN_VALUE_OF") + " " + tr("CALL") + " " + str(last_pop_left) + ")"])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[2, "F_right = " + str(F_right) + " (" + tr("RETURN_VALUE_OF") + " " + tr("CALL") + " " + str(last_pop_right) + ")"])
		])
	
	F.append_array(F_right)
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[11]])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[0, "F = " + str(F)])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[1, "F_left = " + str(F_left) + " (" + tr("RETURN_VALUE_OF") + " " + tr("CALL") + " " + str(last_pop_left) + ")"])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[2, "F_right = " + str(F_right) + " (" + tr("RETURN_VALUE_OF") + " " + tr("CALL") + " " + str(last_pop_right) + ")"])
		])

	# Return F
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[13]])
		,Operation.new(\
			Operation.opcodes.RETURN,\
			[])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_RETURN,\
			[F])
		,Operation.new(\
			Operation.opcodes.SET_TAG,\
			[ptr_target, str(F)])\
		])
	return F
func _on_button_inorder_pressed():
	side_panel.create_variable()
	side_panel.create_variable()
	side_panel.create_variable()
	side_panel.override_code(tr("INORDER"))
	side_panel.override_code_call("inorder(start_ptr)")
	init_algo(inorder, [root_ptr])
	side_panel.select_containers(1, 1, 1, 0)

func levelorder(argv: Array) -> Array:
	var ptr = argv[0]
	
	# Push call
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[]])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_CALL,\
			["levelorder(start_ptr = " + ptr.pointer_name + ")"])\
		,Operation.new(\
			Operation.opcodes.CALL,\
			["CALL"])\
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[0, ""])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[1, ""])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[2, ""])
		])
	
	# Create variables
	var Q: Array = []
	var Q_strings: Array = []
	var F: Array = []
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[1]])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[0, "F = " + str(F)])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[1, "Q = " + str(Q_strings).replace("\"", "")])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[2, ""])
		])

	# Update variables
	Q.push_back(argv[0])
	Q_strings.push_back(argv[0].pointer_name)
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[2]])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[0, "F = " + str(F)])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[1, "Q = " + str(Q_strings).replace("\"", "")])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_VARIABLE,\
			[2, ""])
		])

	while not Q.is_empty():
		push_operations([\
			Operation.new(\
				Operation.opcodes.HIGHLIGHT_CODE,\
				[[4]])
		])
		
		var current_ptr = Q.pop_front()
		Q_strings.pop_front()
		push_operations([\
			Operation.new(\
				Operation.opcodes.HIGHLIGHT_CODE,\
				[[5]])
			,Operation.new(\
				Operation.opcodes.SET_POINTER_COLOR,\
				[current_ptr, pointer_class.colors.ACCENT])\
			,Operation.new(\
				Operation.opcodes.SET_SPRITE,\
				[current_ptr.target, list_vertex_class.sprites.ACCENT])\
			,Operation.new(\
				Operation.opcodes.OVERWRITE_VARIABLE,\
				[0, "F = " + str(F)])
			,Operation.new(\
				Operation.opcodes.OVERWRITE_VARIABLE,\
				[1, "Q = " + str(Q_strings).replace("\"", "")])
			,Operation.new(\
				Operation.opcodes.OVERWRITE_VARIABLE,\
				[2, "current_ptr = " + current_ptr.pointer_name])
		])
		
		push_operations([\
			Operation.new(\
				Operation.opcodes.HIGHLIGHT_CODE,\
				[[6]])
		])
		if current_ptr.target != null:
			F.push_back(current_ptr.target.data)
			Q.push_back(current_ptr.target.p1)
			Q_strings.push_back(current_ptr.target.p1.pointer_name)
			Q.push_back(current_ptr.target.p2)
			Q_strings.push_back(current_ptr.target.p1.pointer_name)
			push_operations([\
				Operation.new(\
					Operation.opcodes.HIGHLIGHT_CODE,\
					[[7, 8, 9]])
				,Operation.new(\
					Operation.opcodes.OVERWRITE_VARIABLE,\
					[0, "F = " + str(F)])
				,Operation.new(\
					Operation.opcodes.OVERWRITE_VARIABLE,\
					[1, "Q = " + str(Q_strings).replace("\"", "")])
				])

	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[11]])
		,Operation.new(\
			Operation.opcodes.RETURN,\
			[])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_RETURN,\
			[F])
		])
	return F
func _on_button_levelorder_pressed():
	side_panel.create_variable()
	side_panel.create_variable()
	side_panel.create_variable()
	side_panel.override_code(tr("LEVELORDER"))
	#side_panel.override_code_call("levelorder(current_ptr = root)")
	init_algo(levelorder, [root_ptr, "root"])
	side_panel.select_containers(1, 1, 1, 0)
