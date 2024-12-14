extends tree_traversal_class


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func insert(argv):
	pass
func _on_button_insert_pressed():
	create_tree([1, 2, 3])
	side_panel.override_code(tr("INS_BST"))
	side_panel.select_containers(1, 0, 0, 0)
	side_panel.override_code_call("balanced_bst.insert(4)")
	init_algo(insert, [4, root_ptr])
	side_panel.open()

func create_tree(array: Array):
	var vertices: Array = []
	for i in array:
		if i >= 0:
			var vertex = vertex_scene.instantiate()
			vertex.set_data(array[i])
			vertices.push_back(vertex)
		else:
			vertices.push_back(-1)
	
	for i in range(array.size()):
		var left = i*2 + 1
		var right = left + 1
		
		if left < array.size() and array[left] >= 0:
			vertices[i].p1.set_target(vertices[left])
		if right < array.size() and array[right] >= 0:
			vertices[i].p1.set_target(vertices[right])
			
	new_ptr.set_target(vertices[0])
	reposition()

func parent(index):
	return int((index - 1) / 2)
