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
		tail.position = tail.target.dest_pos + Vector2(90, -175)

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
			make_shared(head.position + Vector2(-75, 375))
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
	side_panel.override_code_call("list.insert_front(data)")
	side_panel.override_code(tr("INS_FRONT_DL"))
	if empty():
		set_up(6, insert_front_empty, insert_front_empty_b)
	else:
		set_up(7, insert_front, insert_front_b)
	init_algo()

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
			highlight_code([3])
		4:
			new_vertex.p2.set_target(pred)
			highlight_code([4])
		5:
			highlight_code([6])
		6:
			pred.p1.target.p2.set_target(new_vertex)
			highlight_code([7])
		7:
			pred.p1.set_target(new_vertex)
			highlight_code([9])
		8:
			side_panel.override_code_return()
			highlight_code([10])
func insert_after_b(step: int):
	var pred: list_vertex_class = list_vertex_class.selected_vertex
	match step:
		5:
			side_panel.highlight_code([4])
		4:
			side_panel.highlight_code([3])
			size -= 1
		3:
			side_panel.highlight_code([2])
			pred.p1.set_target(new_vertex.p1.target)
		2:
			side_panel.highlight_code([1])
			new_vertex.p1.set_target(null)
		1:
			unshare()
func _on_button_insert_after_pressed():
	side_panel.override_code(tr("INS_AFTER_DL"))
	side_panel.override_code_call("list.insert_after(ListNodeptr pred, data)")
	side_panel.override_exp("Pick a predecessor Node")
	set_up(8, insert_after, insert_after_b, true)

func remove_after(step: int):
	var pred: list_vertex_class = list_vertex_class.selected_vertex
	match step:
		1:
			side_panel.highlight_code([1])
			if pred.p1.target == null:
				crash()
			else:
				to_remove = pred.p1.target
				if to_remove.p1.target != null:
					to_remove.move_to_rel(Vector2(0, 150))
				pred.p1.set_target(pred.p1.target.p1.target)
		2:
			side_panel.highlight_code([1])
			pseudo_remove()
		3:
			side_panel.highlight_code([2])
			size -= 1
		4:
			side_panel.highlight_code([3])
			side_panel.override_code_return()
func remove_after_b(step: int):
	var pred: list_vertex_class = list_vertex_class.selected_vertex
	match step:
		4:
			side_panel.highlight_code([2])
		3:
			side_panel.highlight_code([1])
			size += 1
		2:
			side_panel.highlight_code([1])
			pseudo_remove_undo()
		1:
			side_panel.highlight_code([])
			if crashed:
				uncrash()
			else:
				if pred.p1.target != null:
					to_remove.move_to_rel(Vector2(0, -150))
				pred.p1.set_target(to_remove)
func _on_button_remove_after_pressed():
	side_panel.override_code(tr("RM_DL"))
	side_panel.override_code_call("doubly_list.remove(ListNodeptr pred)")
	side_panel.override_exp("Pick the Node to remove")
	set_up(4, remove_after, remove_after_b, true)
