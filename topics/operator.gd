class_name operator_class extends Node

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
	update_step_label()

func backward():
	if current_step > 0:
		current_step -= 1
		operator_interface(operations_array[current_step], true)
	update_step_label()

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
	new_ptr.set_target(null)
	new_ptr.visible = false
	
	if to_remove != null:
		to_remove.queue_free()
		to_remove = null
	reposition()
	update_step_label()
	get_tree().call_group("pointers", "reset_visuals")
	get_tree().call_group("vertices", "reset_visuals")

func reposition():
	pass

@export var label_progress: Label
func update_step_label():
	label_progress.update_step_label(current_step, operations_array.size())

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
					create_new_vertex_undo()
				else:
					new_vertex = create_new_vertex(argv[0], argv[1])
				continue
			Operation.opcodes.MAKE_SHARED:
				if undo:
					make_shared_undo(new_vertex)
				else:
					make_shared(new_vertex)
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
			Operation.opcodes.SET_POINTER_COLOR:
				if undo:
					argv[0].set_color_undo()
				else:
					argv[0].set_color(argv[1])
			Operation.opcodes.HIGHLIGHT_CODE:
				if undo:
					side_panel.highlight_code_undo()
				else:
					side_panel.highlight_code(argv[0])
				continue
			Operation.opcodes.CREATE_VARIABLE:
				if undo:
					side_panel.create_variable_undo()
				else:
					side_panel.create_variable()
				continue

@export var vertex_scene: PackedScene
func create_new_vertex(position_: Vector2, from: String = "left") -> list_vertex_class:
	new_vertex = vertex_scene.instantiate()
	new_vertex.global_position = position_
	add_child(new_vertex)
	
	new_ptr.set_target(new_vertex)
	match from:
		"left":
			new_ptr.position = new_vertex.position + Vector2(-200, 0)
		"right":
			new_ptr.position = new_vertex.position + Vector2(200, 0)
		"above":
			new_ptr.position = new_vertex.position + Vector2(0, -200)
	
	new_ptr.current_end_point = new_vertex.position
	new_ptr.draw()
	new_ptr.visible = true
	
	return new_vertex
func create_new_vertex_undo():
	new_ptr.visible = false
	new_ptr.set_target(null)
	new_vertex.queue_free()

@export var new_ptr: pointer_class
func make_shared(vertex):
	vertex.visible = true
	new_ptr.visible = true
func make_shared_undo(vertex: list_vertex_class):
	new_ptr.visible = false
	vertex.visible = false

func point_at(pointer: pointer_class, target):
	pointer.set_target(target)
func point_at_undo(pointer: pointer_class):
	pointer.set_target_undo()

var target_before
var to_remove = null
func pseudo_remove() -> void:
	to_remove.visible = false
	target_before = to_remove.p1.target
	to_remove.p1.set_target(null)
func pseudo_remove_undo() -> void:
	to_remove.p1.set_target(target_before)
	if target_before != null:
		to_remove.p1.current_end_point = target_before.global_position
		to_remove.p1.draw()
	to_remove.visible = true

func swap(vertex_1: tree_vertex_class, vertex_2: tree_vertex_class) -> void:
	var buf: int = vertex_1.data
	vertex_1.set_data(vertex_2.data)
	vertex_2.set_data(buf)
