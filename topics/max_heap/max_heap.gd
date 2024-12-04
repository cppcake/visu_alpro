class_name max_heap_class extends tree_traversal_class

func _ready():
	pass

var tree_array: Array = []
func parent(index):
	return int((index - 1) / 2)

func update_stack_frame():
	super.update_stack_frame()
	root_label.text = "tree_array = 0x..."
		

@export var visu_array: VisuArray = null
func insert(argv: Array):
	visu_array.visu_array(to_data_array(tree_array))
	
	var current_ptr = null
	var current_index = tree_array.size()
	if current_index == 0:
		current_ptr = root_ptr
	else:
		var parent_vertex = tree_array[parent(current_index)]
		if tree_array.size() % 2 == 1:
			current_ptr = parent_vertex.p1
		else:
			current_ptr = parent_vertex.p2

	new_vertex = create_new_vertex(current_ptr.current_end_point + Vector2(0, 100), "none")
	new_vertex.set_data(argv[0])
	tree_array.append(new_vertex)
	new_vertex.label_ref_count.visible = false

	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[2, 3]])
		,Operation.new(\
			Operation.opcodes.MAKE_SHARED,\
			[new_vertex])\
		,Operation.new(\
			Operation.opcodes.POINT_AT,\
			[current_ptr, new_vertex])\
		,Operation.new(\
			Operation.opcodes.SET_SPRITE,\
			[new_vertex, list_vertex_class.sprites.ACCENT_2])\
		,Operation.new(\
			Operation.opcodes.VISU_ARRAY,\
			[visu_array, tree_array])\
		,Operation.new(\
			Operation.opcodes.INC_SIZE,\
			[])\
	])
	
	# Move it up! (if needed)
	while current_index > 0 and tree_array[current_index].data > tree_array[parent(current_index)].data:
		push_operations([\
			Operation.new(\
				Operation.opcodes.HIGHLIGHT_CODE,\
				[[7]])\
			,Operation.new(\
				Operation.opcodes.SET_SPRITE,\
				[tree_array[parent(current_index)], list_vertex_class.sprites.ACCENT])\
			,Operation.new(\
				Operation.opcodes.OVERWRITE_VARIABLE,\
				[0, "index = " + str(current_index)])
			,Operation.new(\
				Operation.opcodes.OVERWRITE_VARIABLE,\
				[1, "parent(index) = " + str(parent(current_index))])
		])
		push_operations([\
			Operation.new(\
				Operation.opcodes.HIGHLIGHT_CODE,\
				[[8, 9]])
			,Operation.new(\
				Operation.opcodes.SWAP,\
				[tree_array[current_index], tree_array[parent(current_index)]])\
			,Operation.new(\
				Operation.opcodes.VISU_ARRAY,\
				[visu_array, tree_array])\
			,Operation.new(\
				Operation.opcodes.OVERWRITE_VARIABLE,\
				[0, "index = " + str(parent(current_index))])
		])
		current_index = parent(current_index)
	
	# Return
	push_operations([\
		Operation.new(\
			Operation.opcodes.HIGHLIGHT_CODE,\
			[[11]])
		,Operation.new(\
			Operation.opcodes.OVERWRITE_RETURN,\
			[null])
		])
	return
@export var input_field: LineEdit
func _on_button_insert_pressed():
	side_panel.create_variable()
	side_panel.create_variable()
	side_panel.override_code(tr("MAX_HEAP"))
	side_panel.select_containers(1, 1, 0, 0)
	var input = int(input_field.text)
	side_panel.override_code_call("maxheap.insert(" + str(input) + ")")
	init_algo(insert, [input])
	#side_panel.open()
	input_field.clear()

func remove_max():
	pass
func _on_button_remove_max_pressed():
	pass

func _on_bbutton_reset_pressed():
	reset()
var data_array: Array = []
func _on_button_reset_tut_pressed():
	reset()
	reposition()
	root_ptr.current_end_point = root_ptr.global_position + Vector2(0, 150)
	
	var to_insert = [68, 61, 30, 43, 20, 19, 23, 5, 21, 19, 13]
	size = to_insert.size()
	for number in to_insert:
		insert_no_visuals([number])

	data_array.clear()
	for vertex in tree_array:
		data_array.push_back(vertex.data)
	visu_array.visu_array(data_array.duplicate())
	clean_up()
func reset():
	size = 0
	visu_array.reset()
	tree_array.clear()
	root_ptr.set_target(null)
	get_tree().call_group("vertices", "queue_free")
func insert_no_visuals(argv: Array):
	# Insert it!
	new_vertex = create_new_vertex(root_ptr.current_end_point + Vector2(0, 100), "right")
	new_vertex.set_data(argv[0])
	tree_array.append(new_vertex)
	
	# Do some tree operations for the visuals
	var current_index = tree_array.size() - 1
	if current_index == 0:
		root_ptr.set_target(new_vertex)
	else:
		var parent_vertex = tree_array[parent(current_index)]
		if tree_array.size() % 2 == 0:
			parent_vertex.p1.set_target(new_vertex)
		else:
			parent_vertex.p2.set_target(new_vertex)
	
	# Move it up! (if needed)
	while current_index > 0 and tree_array[current_index].data > tree_array[parent(current_index)].data:
		swap(tree_array[current_index], tree_array[parent(current_index)])
		current_index = parent(current_index)
