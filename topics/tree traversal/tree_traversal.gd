class_name tree_traversal_class extends Node

@export var operator: operator_class
@export var root_ptr: pointer_class
@export var cam: CameraManager

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

var current_step
func init_algo(algo: Callable, argv: Array):
	operations_array.clear()
	algo.call(argv)
	current_step = operations_array.size()
	while current_step > 0:
		backward()

func forward():
	if current_step < operations_array.size():
		operator_interface(operations_array[current_step])
		current_step += 1

func backward():
	if current_step > 0:
		current_step -= 1
		operator_interface(operations_array[current_step], true)

func finish():
	while current_step < operations_array.size():
		forward()
	clean_up()

func cancel():
	while current_step > 0:
		backward()
	clean_up()

func clean_up():
	current_step = 0
	operations_array.clear()
	operator.clean_up()
	reposition()

@export var side_panel: SidePanel
var new_vertex: tree_vertex_class
var operations_array: Array = []
func push_operations(operations: Array):
	operations_array.push_back(operations)
	operator_interface(operations_array.back())
func operator_interface(operations: Array, undo: bool = false):
	for operation: Operation in operations:
		var opcode = operation.opcode
		var argv = operation.argv
		match opcode:
			Operation.opcodes.CREATE_NEW_VERTEX:
				if undo:
					operator.create_new_vertex_undo(new_vertex)
				else:
					new_vertex = operator.create_new_vertex(argv[0], argv[1])
				continue
			Operation.opcodes.MAKE_SHARED:
				if undo:
					operator.make_shared_undo(new_vertex)
				else:
					operator.make_shared(new_vertex)
				continue
			Operation.opcodes.POINT_AT:
				if undo:
					argv[0].set_target_undo()
				else:
					argv[0].set_target(argv[1])
				continue
			Operation.opcodes.SET_SPRITE:
				if undo:
					argv[0].set_sprite_undo()
				else:
					argv[0].set_sprite(argv[1])
				continue
			Operation.opcodes.HIGHLIGHT_CODE:
				if undo:
					side_panel.highlight_code_undo()
				else:
					side_panel.highlight_code(argv[0])
				continue

func insert(argv: Array):
	var data = argv[0]
	var ptr = argv[1]
	var root = ptr.target
	if root == null:
		new_vertex = operator.create_new_vertex(ptr.global_position + Vector2(0, 250), "right")
		new_vertex.set_data(data)
		
		push_operations([\
							Operation.new(\
								Operation.opcodes.MAKE_SHARED,\
								[new_vertex]),
							Operation.new(\
								Operation.opcodes.SET_SPRITE,\
								[new_vertex, list_vertex_class.sprites.ACCENT])\
						])
		
		push_operations([\
							Operation.new(\
								Operation.opcodes.POINT_AT,\
								[ptr, new_vertex]),
							Operation.new(\
								Operation.opcodes.SET_SPRITE,\
								[new_vertex, list_vertex_class.sprites.TO_REMOVE])\
						])
		return
	
	if root.data > data:
		insert([data, root.p1])
	else:
		insert([data, root.p2])
func _on_button_insert_pressed():
	var randiii: int = randi() % 100
	init_algo(insert, [randiii, root_ptr])
