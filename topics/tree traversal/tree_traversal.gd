class_name tree_traversal_class extends Node

@export var operator: operator_class
@export var root_ptr: pointer_class
@export var v1: tree_vertex_class
@export var v2: tree_vertex_class
@export var v3: tree_vertex_class
@export var v4: tree_vertex_class
@export var v5: tree_vertex_class
@export var v6: tree_vertex_class
@export var v7: tree_vertex_class
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

func finish():
	while current_step < operations.size():
		forward()
	clean_up()

func cancel():
	while current_step > 0:
		backward()
	clean_up()

func clean_up():
	current_step = 0
	operations.clear()
	operator.clean_up()
	reposition()

var current_step = 0
func forward():
	if current_step < operations.size():
		operator_interface(operations[current_step])
		current_step += 1

func backward():
	if current_step > 0:
		current_step -= 1
		operator_interface(operations[current_step], true)

func init_algo(algo: Callable, argv: Array):
	operations.clear()
	algo.call(argv)
	current_step = operations.size()
	while current_step > 0:
		backward()

var operations: Array = []
func push_operation(operation_name: String, argv: Array):
	operations.push_back([operation_name, argv])
	operator_interface(operations.back())
func operator_interface(operation: Array, undo: bool = false):
	var operation_name = operation[0]
	var argv = operation[1]
	
	match operation_name:
		"create_new_vertex":
			if undo:
				operator.create_new_vertex_undo(new_vertex)
			else:
				new_vertex = operator.create_new_vertex(argv[0], argv[1])
			return
		"make_shared":
			if undo:
				operator.make_shared_undo(new_vertex)
			else:
				operator.make_shared(new_vertex)
			return
		"point_at":
			if undo:
				argv[0].set_target_undo()
			else:
				argv[0].set_target(argv[1])
			return

var new_vertex: tree_vertex_class
func insert(argv: Array):
	var data = argv[0]
	var ptr = argv[1]
	var root = ptr.target
	if root == null:
		new_vertex = operator.create_new_vertex(ptr.global_position + Vector2(0, 250), "right")
		new_vertex.set_data(data)
		push_operation("make_shared", [new_vertex])
		
		push_operation("point_at", [ptr, new_vertex])
		return
	
	if root.data > data:
		insert([data, root.p1])
	else:
		insert([data, root.p2])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var left_click = Input.is_action_just_pressed("M1")
	var right_click = Input.is_action_just_pressed("M2")
	var middle_click = Input.is_action_just_pressed("M3")
	if right_click:
		pass

	if middle_click:
		pass

func _on_button_insert_pressed():
	var randiii: int = randi() % 100
	init_algo(insert, [randiii, root_ptr])
