class_name doubly_list_class extends simple_list_class

@export var tail: pointer_class

func _ready():
	super._ready()
	list_v_scene = preload("res://structs/doubly_list/doubly_list_vertex.tscn")

@export var tail_label: Label
func update_stack_frame():
	super.update_stack_frame()
	if tail.target == null:
		tail_label.text = "tail = null"
	else:
		tail_label.text = "tail = 0x..."

func reposition_list():
	super.reposition_list()
	if not empty():
		tail.move_to(tail.target.dest_pos + Vector2(90, -175))
	else:
		tail.move_to(head.position + Vector2(180, 0))
var current_decider = null
func set_up_decisive(new_decider: Callable):
	side_panel.open()
	current_decider = new_decider
	prepare_signals_for_current()
func get_current_for_algo(_viewport, event, _shape_idx):
	# Check if the event is an InputEventMouseButton
	if event is InputEventMouseButton:
		# Check if it's a left-click (left mouse button has index 1)
		if event.button_index == 1 and event.pressed:
			while list_vertex_class.selected_vertex == null:
				pass
			current_decider.call(list_vertex_class.selected_vertex)
			init_algo()
			for child in self.get_children():
				if type_string(typeof(child)) == "Object":
					if child is list_vertex_class:
						child.disconnect("input_event", get_current_for_algo)
func prepare_signals_for_current() -> void:
	for child in self.get_children():
		if type_string(typeof(child)) == "Object":
			if child is list_vertex_class:
				if not child.is_connected("input_event", get_current_for_algo):
					child.connect("input_event", get_current_for_algo)

func reset():
	list_v_scene = preload("res://structs/doubly_list/doubly_list_vertex.tscn")
	tail.target = null
	super.reset()

func insert_front_empty(step: int):
	match step:
		0:
			side_panel.override_exp(tr("INS_FRONT_0"))
		1:
			size += 1
			highlight_code([1])
		2:
			make_shared(head.position + Vector2(-75, 375))
			highlight_code([2])
		3:
			highlight_code([5])
		4:
			head.set_target(new_vertex)
			highlight_code([6])
		5:
			tail.set_target(new_vertex)
			highlight_code([7])
		6:
			side_panel.override_code_return()
			highlight_code([8])
func insert_front_empty_b(step: int):
	match step:
		1:
			size -= 1
		2:
			unshare()
		3:
			pass
		4:
			head.set_target_undo()
		5:
			tail.set_target_undo()
		6:
			pass
func insert_front(step: int):
	match step:
		0:
			pass
		1:
			size += 1
			highlight_code([1])
		2:
			make_shared(head.position + Vector2(-75, 300))
			highlight_code([2])
		3:
			highlight_code([5])
		4:
			new_vertex.p1.set_target(head.target)
			highlight_code([12])
		5:
			head.target.p2.set_target(new_vertex)
			highlight_code([13])
		6:
			head.set_target(new_vertex)
			highlight_code([14])
		7:
			side_panel.override_code_return()
			highlight_code([15])
func insert_front_b(step: int):
	match step:
		1:
			size -= 1
		2:
			unshare()
		3:
			pass
		4:
			new_vertex.p1.set_target_undo()
		5:
			head.target.p2.set_target_undo()
		6:
			head.set_target_undo()
		7:
			pass
func _on_button_insert_front_pressed():
	to_remove = null
	side_panel.override_code_call("list.insert_front(data)")
	side_panel.override_code(tr("INS_FRONT_DL"))
	if empty():
		set_up(6, insert_front_empty, insert_front_empty_b)
	else:
		set_up(7, insert_front, insert_front_b)
	init_algo()

func insert_after_case_decider(pred: list_vertex_class):
	make_current(pred)
	if pred == tail.target:
		set_up(8, insert_after_tail, insert_after_tail_b)
	else:
		set_up(8, insert_after, insert_after_b)
func insert_after(step: int):
	var pred: list_vertex_class = list_vertex_class.selected_vertex
	match step:
		0:
			pass
		1:
			size += 1
			highlight_code([1])
		2:
			make_shared(pred.position + Vector2(125, -250))
			highlight_code([2])
		3:
			new_vertex.p1.set_target(pred.p1.target)
			highlight_code([4])
		4:
			new_vertex.p2.set_target(pred)
			highlight_code([5])
		5:
			pred.p1.set_target(new_vertex)
			highlight_code([6])
		6:
			highlight_code([8])
		7:
			new_vertex.p1.target.p2.set_target(new_vertex)
			highlight_code([9])
		8:
			side_panel.override_code_return()
			highlight_code([10])
func insert_after_b(step: int):
	var pred: list_vertex_class = list_vertex_class.selected_vertex
	match step:
		1:
			size -= 1
		2:
			unshare()
		3:
			new_vertex.p1.set_target_undo()
		4:
			new_vertex.p2.set_target_undo()
		5:
			pred.p1.set_target_undo()
		6:
			pass
		7:
			new_vertex.p1.target.p2.set_target_undo()
		8:
			pass
func insert_after_tail(step: int):
	var pred: list_vertex_class = list_vertex_class.selected_vertex
	match step:
		0:
			pass
		1:
			size += 1
			highlight_code([1])
		2:
			make_shared(pred.position + Vector2(250, 0), "right")
			highlight_code([2])
		3:
			new_vertex.p1.set_target(pred.p1.target)
			highlight_code([4])
		4:
			new_vertex.p2.set_target(pred)
			highlight_code([5])
		5:
			pred.p1.set_target(new_vertex)
			highlight_code([6])
		6:
			highlight_code([8])
		7:
			tail.set_target(new_vertex)
			highlight_code([13])
		8:
			side_panel.override_code_return()
			highlight_code([14])
func insert_after_tail_b(step: int):
	var pred: list_vertex_class = list_vertex_class.selected_vertex
	match step:
		1:
			size -= 1
		2:
			unshare()
		3:
			new_vertex.p1.set_target_undo()
		4:
			new_vertex.p2.set_target_undo()
		5:
			pred.p1.set_target_undo()
		6:
			pass
		7:
			tail.set_target_undo()
		8:
			pass
func _on_button_insert_after_pressed():
	to_remove = null
	side_panel.override_code(tr("INS_AFTER_DL"))
	side_panel.override_code_call("list.insert_after(ListNodeptr pred, data)")
	side_panel.override_exp("Pick a predecessor Node")
	current.label_start.text = "pred"
	set_up_decisive(insert_after_case_decider)

func remove_case_decider(remove_ptr: list_vertex_class):
	if size == 1:
		make_current(remove_ptr, "right")
		set_up(5, remove_one, remove_one_b)
		return
	if head.target == remove_ptr:
		make_current(remove_ptr, "right")
		set_up(6, remove_head, remove_head_b)
		return
	if tail.target == remove_ptr:
		make_current(remove_ptr, "left")
		set_up(7, remove_tail, remove_tail_b)
		return
	make_current(remove_ptr)
	set_up(8, remove, remove_b)
func remove_one(step: int):
	to_remove = list_vertex_class.selected_vertex
	match step:
		1:
			size -= 1
			highlight_code([1])
		2:
			highlight_code([4])
		3:
			head.set_target(null)
			highlight_code([5])
		4:
			tail.set_target(null)
			highlight_code([6])
		5:
			side_panel.override_code_return()
			highlight_code([7])
func remove_one_b(step: int):
	to_remove = list_vertex_class.selected_vertex
	match step:
		1:
			size += 1
			highlight_code_undo()
		2:
			pass
		3:
			head.set_target_undo()
		4:
			tail.set_target_undo()
		5:
			pass
func remove_head(step: int):
	to_remove = list_vertex_class.selected_vertex
	match step:
		1:
			size -= 1
			highlight_code([1])
		2:
			highlight_code([4])
		3:
			highlight_code([11])
		4:
			head.set_target(head.target.p1.target)
			highlight_code([12])
		5:
			head.target.p2.set_target(null)
			highlight_code([13])
		6:
			side_panel.override_code_return()
			highlight_code([14])
func remove_head_b(step: int):
	to_remove = list_vertex_class.selected_vertex
	match step:
		1:
			size += 1
			highlight_code_undo()
		2:
			pass
		3:
			pass
		4:
			head.set_target_undo()
		5:
			head.target.p2.set_target_undo()
		6:
			pass
func remove_tail(step: int):
	to_remove = list_vertex_class.selected_vertex
	match step:
		1:
			size -= 1
			highlight_code([1])
		2:
			highlight_code([4])
		3:
			highlight_code([11])
		4:
			highlight_code([18])
		5:
			tail.set_target(tail.target.p2.target)
			highlight_code([19])
		6:
			tail.target.p1.set_target(null)
			highlight_code([20])
		7:
			side_panel.override_code_return()
			highlight_code([21])
func remove_tail_b(step: int):
	to_remove = list_vertex_class.selected_vertex
	match step:
		1:
			size += 1
			highlight_code_undo()
		2:
			pass
		3:
			pass
		4:
			pass
		5:
			tail.set_target_undo()
		6:
			tail.target.p1.set_target_undo()
		7:
			pass
func remove(step: int):
	to_remove = list_vertex_class.selected_vertex
	match step:
		1:
			size -= 1
			highlight_code([1])
		2:
			highlight_code([4])
		3:
			highlight_code([11])
		4:
			highlight_code([18])
		5:
			to_remove.move_to_rel(Vector2(0, -200))
			current.move_to_rel(Vector2(0, -200))
			to_remove.p1.target.p2.set_target(to_remove.p2.target)
			highlight_code([25])
		6:
			current.dest_pos = null
			to_remove.p2.target.p1.set_target(to_remove.p1.target)
			highlight_code([26])
		7:
			side_panel.override_code_return()
			highlight_code([27])
func remove_b(step: int):
	to_remove = list_vertex_class.selected_vertex
	match step:
		1:
			size += 1
			highlight_code_undo()
		2:
			pass
		3:
			pass
		4:
			pass
		5:
			to_remove.move_to_rel(Vector2(0, 200))
			current.move_to_rel(Vector2(0, 200))
			to_remove.p1.target.p2.set_target_undo()
		6:
			to_remove.p2.target.p1.set_target_undo()
		7:
			pass
func _on_button_remove_after_pressed():
	side_panel.override_code(tr("RM_DL"))
	side_panel.override_code_call("DListNodeptr DoublyLinkedList::remove(const DListNodeptr& to_remove_ptr)")
	side_panel.override_exp("Pick the Node to remove")
	current.label_start.text = "to_remove_ptr"
	set_up_decisive(remove_case_decider)
