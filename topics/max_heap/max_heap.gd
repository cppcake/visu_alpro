class_name max_heap_class extends tree_traversal_class

func _ready():
	pass

var tree_array: Array = []
func parent(index):
	return int((index - 1) / 2)

func insert(argv: Array):
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


@export var input_field: LineEdit
func _on_button_insert_pressed():
	side_panel.override_code(tr("INS_BST"))
	side_panel.select_containers(1, 0, 0, 0)
	var input = int(input_field.text)
	side_panel.override_code_call("bst.insert(root_ptr, " + str(input) + ")")
	init_algo(insert, [input])
	side_panel.open()

# 1, 2
func _on_button_inorder_pressed():
	swap(tree_array[1], tree_array[0])

