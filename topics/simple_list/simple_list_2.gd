extends operator_class

@export var head: pointer_class
@export var current: pointer_class
func _ready():
	reset()
	side_panel.reset()
	side_panel.select_containers(0, 0, 0, 1)
	side_panel.override_exp(tr("TUTORIAL"))
	side_panel.open()

func clean_up():
	super.clean_up()
	make_current(null)

func reset():
	size = 0
	head.target = null
	for child in get_children():
		if child is list_vertex_class:
			child.queue_free()
	clean_up()
	_on_button_insert_front_pressed()
	finish()
	_on_button_insert_front_pressed()
	finish()
	_on_button_insert_front_pressed()
	finish()

func reposition():
	if head.target == null:
		head.position = Vector2(0, 0)
	else:
		var current_ = head.target
		var pos = head.position + Vector2(90, 175)
		while current_ != null:
			current_.move_to(pos)
			pos += Vector2(250, 0)
			current_ = current_.p1.target

func insert_front(argv := []):
		if head.target == null:
			create_new_vertex(head.position + Vector2(0, 200))
		else:
			create_new_vertex(head.position + Vector2(-50, 325))
		
		new_vertex.visible = false
		new_ptr.visible = false
		push_operations([
					Operation.new(
							Operation.opcodes.TOGGLE_VISIBLE,
							[new_vertex, new_ptr]),
					Operation.new(
							Operation.opcodes.HIGHLIGHT_CODE,
							[[1]]),
			])
		
		push_operations([
					Operation.new(
							Operation.opcodes.POINT_AT,
							[new_vertex.p1, head.target]),
					Operation.new(
							Operation.opcodes.HIGHLIGHT_CODE,
							[[2]]),
			])
			
		push_operations([
					Operation.new(
							Operation.opcodes.POINT_AT,
							[head, new_vertex]),
					Operation.new(
							Operation.opcodes.HIGHLIGHT_CODE,
							[[3]]),
			])

		push_operations([
					Operation.new(
							Operation.opcodes.INC_SIZE,
							[]),
					Operation.new(
							Operation.opcodes.HIGHLIGHT_CODE,
							[[4]]),
			])
			
		push_operations([
					Operation.new(
							Operation.opcodes.OVERWRITE_RETURN,
							[null]),
					Operation.new(
							Operation.opcodes.HIGHLIGHT_CODE,
							[[5]]),
			])
func _on_button_insert_front_pressed():
	to_remove = null
	
	var content = str("ListNodeptr new_node_ptr = std::make_shared<ListNode>[b]([/b]data[b])[/b];\nnew_node_ptr->next = head;\nhead = new_node_ptr;\nsize += 1;\n[b]return[/b];\n")
	
	side_panel.override_code_call("list.insert_front(data)")
	side_panel.override_code(content)
	side_panel.select_containers(1, 0, 0, 0)
	side_panel.open()
	init_algo(insert_front)

func remove_front(argv := []):
	if head.target == null:
		push_operations([
					Operation.new(
							Operation.opcodes.CRASH,
							[]),
					Operation.new(
							Operation.opcodes.HIGHLIGHT_CODE,
							[[1]]),
			])
		return
	else:
		to_remove = head.target
		push_operations([
					Operation.new(
							Operation.opcodes.POINT_AT,
							[head, head.target.p1.target]),
					Operation.new(
							Operation.opcodes.HIGHLIGHT_CODE,
							[[1]]),
			])
			
		push_operations([
					Operation.new(
							Operation.opcodes.DEC_SIZE,
							[]),
					Operation.new(
							Operation.opcodes.POINT_AT,
							[to_remove.p1, null]),
					Operation.new(
							Operation.opcodes.TOGGLE_VISIBLE,
							[to_remove]),
					Operation.new(
							Operation.opcodes.HIGHLIGHT_CODE,
							[[1]]),
			])

	push_operations([
					Operation.new(
							Operation.opcodes.DEC_SIZE,
							[]),
					Operation.new(
							Operation.opcodes.HIGHLIGHT_CODE,
							[[2]]),
			])

	push_operations([
					Operation.new(
							Operation.opcodes.OVERWRITE_RETURN,
							[null]),
					Operation.new(
							Operation.opcodes.HIGHLIGHT_CODE,
							[[3]]),
			])
func _on_button_remove_front_pressed():
	var content = str("head = head->next;\nsize -= 1;\n[b]return[/b];\n")
	
	side_panel.override_code_call("list.remove_front()")
	side_panel.override_code(content)
	side_panel.select_containers(1, 0, 0, 0)
	side_panel.open()
	init_algo(remove_front)

var pre_algo
func make_current(target, from: String = "above"):
	current.set_target(target)
	if target == null:
		current.visible = false
		current.position = Vector2(9000, 9000)
	else:
		match from:
			"above":
				current.position = target.position + Vector2(0, -200)
			"left":
				current.position = target.position + Vector2(200, 0)
			"right":
				current.position = target.position + Vector2(-200, 0)
		current.current_end_point = target.position
		current.draw()
		current.visible = true
func get_current_for_algo(_viewport, event, _shape_idx):
	# Check if the event is an InputEventMouseButton
	if event is InputEventMouseButton:
		# Check if it's a left-click (left mouse button has index 1)
		if event.button_index == 1 and event.pressed:
			while list_vertex_class.selected_vertex == null:
				pass
			make_current(list_vertex_class.selected_vertex)
			for child in self.get_children():
				if type_string(typeof(child)) == "Object":
					if child is list_vertex_class:
						child.disconnect("input_event", get_current_for_algo)
			side_panel.select_containers(1, 0, 0, 0)
			init_algo(pre_algo)
func prepare_signals_for_current() -> void:
	for child in self.get_children():
		if type_string(typeof(child)) == "Object":
			if child is list_vertex_class:
				if not child.is_connected("input_event", get_current_for_algo):
					child.connect("input_event", get_current_for_algo)

func insert_after(argv := []):
	var pred: list_vertex_class = list_vertex_class.selected_vertex
	create_new_vertex(pred.position + Vector2(125, -175), "above")
	new_vertex.visible = false
	new_ptr.visible = false
	
	push_operations([
					Operation.new(
							Operation.opcodes.TOGGLE_VISIBLE,
							[new_vertex, new_ptr]),
					Operation.new(
							Operation.opcodes.HIGHLIGHT_CODE,
							[[1]]),
			])
	
	push_operations([
					Operation.new(
							Operation.opcodes.POINT_AT,
							[new_vertex.p1, pred.p1.target]),
					Operation.new(
							Operation.opcodes.HIGHLIGHT_CODE,
							[[2]]),
			])

	push_operations([
					Operation.new(
							Operation.opcodes.POINT_AT,
							[pred.p1, new_vertex]),
					Operation.new(
							Operation.opcodes.HIGHLIGHT_CODE,
							[[3]]),
			])

	push_operations([
					Operation.new(
							Operation.opcodes.INC_SIZE,
							[]),
					Operation.new(
							Operation.opcodes.HIGHLIGHT_CODE,
							[[4]]),
			])

	push_operations([
					Operation.new(
							Operation.opcodes.OVERWRITE_RETURN,
							[null]),
					Operation.new(
							Operation.opcodes.HIGHLIGHT_CODE,
							[[5]]),
			])
func _on_button_insert_after_pressed():
	to_remove = null
	
	var content = "ListNodeptr new_node_ptr = std::make_shared<ListNode>[b]([/b]data[b])[/b];\nnew_node_ptr->next = pred→next;\npred->next = new_node_ptr;\nsize += 1;\n[b]return[/b];\n"
	
	side_panel.override_code(content)
	side_panel.override_code_call("list.insert_after(ListNodeptr pred, data)")
	side_panel.override_exp(tr("PICK_PRE"))
	side_panel.select_containers(0, 0, 0, 1)
	side_panel.open()
	pre_algo = insert_after
	prepare_signals_for_current()

func remove_after(argv := []):
	pass
func _on_button_remove_after_pressed():
	var content = "pred->next = pred->next->next;\nsize -= 1;\n[b]return[/b];\n"
	
	side_panel.override_code(content)
	side_panel.override_code_call("list.remove_after(ListNodeptr pred)")
	side_panel.override_exp(tr("PICK_PRE"))
	side_panel.select_containers(0, 0, 0, 1)
	side_panel.open()
	pre_algo = remove_after
	prepare_signals_for_current()
