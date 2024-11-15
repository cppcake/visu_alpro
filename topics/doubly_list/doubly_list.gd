class_name doubly_list_class extends simple_list_class

func _ready():
	super._ready()
	list_v_scene = preload("res://structs/doubly_list/doubly_list_vertex.tscn")

func reposition_list():
	super.reposition_list()
	if not empty():
		tail.position = tail.target.dest_pos + Vector2(90, -175)

func insert_front(step: int):
	match step:
		0:
			side_panel.override_exp(tr("INS_FRONT_0"))
		1:
			size += 1
			side_panel.highlight_code([1])
		2:
			make_shared(head.position + Vector2(-50, 325))
			side_panel.highlight_code([2])
		3:
			side_panel.highlight_code([5])
		4:
			if empty():
				side_panel.highlight_code([6, 7])
				head.set_target(new_vertex)
				tail.set_target(new_vertex)
		5:
			if size == 1:
				side_panel.highlight_code([8])
				side_panel.override_code_return()
func insert_front_b(step: int):
	match step:
		1:
			size -= 1
			side_panel.highlight_code([])
		2:
			unshare()
			side_panel.highlight_code([1])
		3:
			side_panel.highlight_code([2])
		4:
			if size == 1:
				side_panel.highlight_code([5])
				head.set_target(null)
				tail.set_target(null)
				return
		5:
			side_panel.highlight_code([6, 7])
func _on_button_insert_front_pressed():
	side_panel.override_code_call("list.insert_front(data)")
	side_panel.override_code(tr("INS_FRONT_DL"))
	set_up(5, insert_front, insert_front_b)
	init_algo()

func insert_after(step: int):
	var pred: list_vertex_class = list_vertex_class.selected_vertex
	match step:
		1:
			make_shared(pred.position + Vector2(125, -175), "above")
			side_panel.highlight_code([1])
		2:
			new_vertex.p1.set_target(pred.p1.target)
			side_panel.highlight_code([2])
		3:
			pred.p1.set_target(new_vertex)
			side_panel.highlight_code([3])
		4:
			size += 1
			side_panel.highlight_code([4])
		5:
			side_panel.highlight_code([5])
			side_panel.override_code_return()
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
	side_panel.override_code(tr("INS_AFTER"))
	side_panel.override_code_call("list.insert_after(ListNodeptr pred, data)")
	side_panel.override_exp("Pick a predecessor Node")
	set_up(5, insert_after, insert_after_b, true)

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
