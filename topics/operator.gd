class_name operator_class extends Node

var current_step
func init_algo(algo: Callable, argv: Array):
	algo.call(argv)
	current_step = operations_array.size()
	while current_step > 0:
		backward()
	side_panel.open()

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
	side_panel.reset()
	side_panel.select_containers(0, 0, 0, 1)
	side_panel.close()

@export var size_label: Label
func _physics_process(delta):
	update_stack_frame()

var size = 0
func update_stack_frame():
	size_label.text = "size = " + str(size)

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
					if not argv[0] == null:
						argv[0].set_sprite_undo()
				else:
					if not argv[0] == null:
						argv[0].set_sprite(argv[1])
				continue
			Operation.opcodes.SET_TAG:
				if undo:
					if not argv[0] == null:
						argv[0].set_tag_undo()
				else:
					if not argv[0] == null:
						argv[0].set_tag(argv[1])
				continue
			Operation.opcodes.SET_POINTER_COLOR:
				if undo:
					argv[0].set_color_undo()
				else:
					argv[0].set_color(argv[1])
				continue
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
			Operation.opcodes.OVERWRITE_VARIABLE:
				if undo:
					side_panel.overwrite_variable_undo(argv[0])
				else:
					side_panel.overwrite_variable(argv[0], argv[1])
				continue
			Operation.opcodes.OVERWRITE_CALL:
				if undo:
					side_panel.override_code_call_undo()
				else:
					side_panel.override_code_call(argv[0])
				continue
			Operation.opcodes.OVERWRITE_RETURN:
				if undo:
					side_panel.override_code_return_v2_undo()
				else:
					side_panel.override_code_return_v2(argv[0])
				continue
			Operation.opcodes.CALL:
				if undo:
					side_panel.create_stackframe_undo()
				else:
					side_panel.create_stackframe(argv[0])
				continue
			Operation.opcodes.RETURN:
				if undo:
					side_panel.remove_stackframe_undo()
				else:
					side_panel.remove_stackframe()
				continue
			Operation.opcodes.SWAP:
				if undo:
					swap_undo()
				else:
					swap(argv[0], argv[1])
				continue
			Operation.opcodes.VISU_ARRAY:
				if undo:
					argv[0].visu_array_undo()
				else:
					argv[0].visu_array(to_data_array(argv[1]))
			Operation.opcodes.INC_SIZE:
				if undo:
					size -= 1
				else:
					size += 1

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

var swap_history: Array = []
func swap(vertex_1: tree_vertex_class, vertex_2: tree_vertex_class, save: bool = true) -> void:
	if save:
		swap_history.push_back([vertex_1, vertex_2])
	var buf: int = vertex_1.data
	vertex_1.set_data(vertex_2.data)
	vertex_2.set_data(buf)
	
	var buf_2 = vertex_1.sprite.texture
	vertex_1.sprite.texture = vertex_2.sprite.texture
	vertex_2.sprite.texture = buf_2
func swap_undo():
	var last_swap = swap_history.pop_back()
	swap(last_swap[0], last_swap[1], false)

func to_data_array(tree_array):
	var data_array: Array = []
	for vertex in tree_array:
		data_array.push_back(vertex.data)
	return data_array

func _on_button_to_start_pressed():
	while current_step > 0:
		backward()
func _on_button_to_end_pressed():
	while current_step < operations_array.size():
		forward()
