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

	new_vertex = create_new_vertex(current_ptr.current_end_point + Vector2(0, 100), "right")
	new_vertex.set_data(argv[0])
	tree_array.append(new_vertex)
	
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
	side_panel.override_code(tr("MAX_HEAP"))
	side_panel.select_containers(1, 0, 0, 0)
	var input = int(input_field.text)
	side_panel.override_code_call("maxheap.insert(" + str(input) + ")")
	init_algo(insert, [input])
	side_panel.open()
	input_field.clear()


func remove_max():
	pass#swap(tree_array[0], tree_array[tree_array.size() - 1]) 
func _on_button_remove_max_pressed():
	pass # Replace with function body.
