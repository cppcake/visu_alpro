extends Node

@export var head: pointer_class
var size: int = 0

@onready var list_v_scene = preload("res://graph/list_vertex.tscn")

@export var side_panel: SidePanel
func _ready():
	clean_up()

func _process(_delta):
	update_stack_frame()

var current_algo: Callable
var current_algo_b: Callable
var current_step: int = 0
var max_step: int = 0
var crashed: bool = false
func forward():
	print(max_step)
	if current_step == max_step or crashed:
		return
		
	current_step = current_step + 1
	current_algo.call(current_step)
	
	update_step_label()

func backward():
	if current_step == max_step:
		side_panel.override_code_return("")
	if current_step == 1:
		side_panel.highlight_code([])
	if current_step == 0:
		return
	
	current_algo_b.call(current_step)
	current_step = current_step - 1
	
	update_step_label()

func finish():
	while current_step < max_step:
		forward()
		if crashed:
			cancel()
			return	
	clean_up()
	
	if to_remove != null:
		to_remove.queue_free()
	
	reposition_list()

func cancel():
	while current_step > 0:
		backward()
	clean_up()
	reposition_list()

func clean_up():
	side_panel.close()
	
	current_step = 0
	max_step= 0
	unshare(false)
	make_current(null)
	update_step_label()
	
	side_panel.reset()
	side_panel.select_containers(0, 0, 0, 1)

func set_up():
	side_panel.open()

func reposition_list():
	if head.target == null:
		head.position = Vector2(0, 0)
	else:
		var current_ = head.target
		var pos = head.position + Vector2(90, 175)
		while current_ != null:
			current_.move_to(pos)
			pos += Vector2(250, 0)
			current_ = current_.p1.target

@export var current: pointer_class
func make_current(target):
	if target == null:
		current.visible = false
		current.set_target(null)
		current.position = Vector2(9000, 9000)
	else:
		current.set_target(target)
		current.position = target.position + Vector2(0, -200)
		current.current_end_point = target.position
		current.draw()
		current.visible = true	

@export var new: pointer_class
func make_shared(position_: Vector2, from: String = "left") -> list_vertex_class:
	var new_v = list_v_scene.instantiate()
	new_v.position = position_
	new_vertex = new_v
	add_child(new_v)	
	
	new.set_target(new_v)
	match from:
		"left":
			new.position = new_v.position + Vector2(-150, 0)
		"above":
			new.position = new_v.position + Vector2(0, -150)
	new.current_end_point = new_v.position
	new.draw()
	new.visible = true
	
	return new_v

func unshare(remove: bool = true) -> void:
	new.visible = false
	new.position = Vector2(4200, 3900)
	new.set_target(null)
	
	if remove:
		new_vertex.queue_free()

@export var label_progress: Label
func update_step_label():
	label_progress.update_step_label(current_step, max_step)

@export var size_label: Label
@export var head_label: Label
func update_stack_frame():
	size_label.text = "size = " + str(size)
	if head.target == null:
		head_label.text = "head = null"
	else:
		head_label.text = "head = 0x..."

func init_algo(max_step_: int = max_step, current_algo_: Callable = current_algo, current_algo_b_: Callable = current_algo_b):
	current_step = 0
	max_step = max_step_
	current_algo = current_algo_
	current_algo_b = current_algo_b_
	
	update_step_label()
	side_panel.select_containers(1, 0, 0, 1)
	side_panel.override_code_return("")
	current_algo.call(current_step)

var max_step_pre: int
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
						max_step = max_step_pre
						child.disconnect("input_event", get_current_for_algo)
						init_algo()

func prepare_signals_for_current() -> void:
	for child in self.get_children():
		if type_string(typeof(child)) == "Object":
			if child is list_vertex_class:
				if not child.is_connected("input_event", get_current_for_algo):
					child.connect("input_event", get_current_for_algo)

var target_before
func pseudo_remove():
	to_remove.visible = false
	target_before = to_remove.p1.target
	to_remove.p1.set_target(null)
func pseudo_remove_undo():
	to_remove.p1.set_target(target_before)
	if target_before != null:
		to_remove.p1.current_end_point = target_before.global_position
		to_remove.p1.draw()
	to_remove.visible = true

func crash():
	side_panel.override_code("[color=red][b]Segmentation fault (core dumped)[/b][/color]", false)
	crashed = true

var new_vertex: list_vertex_class
var to_remove = null

func insert_front(step: int):
	match step:
		0:
			side_panel.override_exp(tr("INS_FRONT_0"))
		1:
			side_panel.override_exp(tr("INS_FRONT_1"))
			if head.target == null:
				make_shared(head.position + Vector2(0, 200))
			else:
				make_shared(head.position + Vector2(0, 325))
			side_panel.highlight_code([1])
		2:
			new_vertex.p1.set_target(head.target)
			side_panel.highlight_code([2])
		3:
			head.set_target(new_vertex)
			side_panel.highlight_code([3])
		4:
			size += 1
			side_panel.highlight_code([4])
		5:
			side_panel.highlight_code([5])
			side_panel.override_code_return()
func insert_front_b(step: int):
	match step:
		5:
			side_panel.highlight_code([4])
		4:
			size -= 1
			side_panel.highlight_code([3])
		3:
			head.set_target(new_vertex.p1.target)
			side_panel.highlight_code([2])
		2:
			new_vertex.p1.set_target(null)
			side_panel.highlight_code([1])
		1:
			unshare()
			side_panel.override_exp(tr("INS_FRONT_0"))
func _on_button_insert_front_pressed():
	side_panel.override_code_call("list.insert_front(data)")
	side_panel.override_code(tr("INS_FRONT"))
	set_up()
	init_algo(5, insert_front, insert_front_b)

func remove_front(step: int):
	match step:
		1:
			if head.target == null:
				crash()
			else:
				to_remove = head.target
				head.set_target(head.target.p1.target)
				side_panel.highlight_code([1])
		2:
			pseudo_remove()
			side_panel.highlight_code([1])
		3:
			size -= 1
			side_panel.highlight_code([2])
		4:
			side_panel.override_code_return()
			side_panel.highlight_code([3])
func remove_front_b(step: int):
	match step:
		1:
			if crashed:
				crashed = false
			else:
				head.set_target(to_remove)
				side_panel.highlight_code([])
		2:
			pseudo_remove_undo()
			side_panel.highlight_code([1])
		3:
			size += 1
			side_panel.highlight_code([1])
		4:
			side_panel.highlight_code([2])
func _on_button_remove_front_pressed():
	side_panel.override_code_call("list.remove_front()")
	side_panel.override_code(tr("RM_FRONT"))
	set_up()
	init_algo(4, remove_front, remove_front_b)

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
	set_up()
	max_step_pre = 5
	current_algo = insert_after
	current_algo_b = insert_after_b
	prepare_signals_for_current()

func remove_after(step: int):
	var pred: list_vertex_class = list_vertex_class.selected_vertex
	match step:
		1:
			if pred.p1.target == null:
				crash()
			else:
				side_panel.highlight_code([1])
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
			if crashed:
				crashed = false
			else:
				side_panel.highlight_code([])
				if pred.p1.target != null:
					to_remove.move_to_rel(Vector2(0, -150))
				pred.p1.set_target(to_remove)
func _on_button_remove_after_pressed():
	side_panel.override_code(tr("RM_AFTER"))
	side_panel.override_code_call("list.remove_after(ListNodeptr pred)")
	side_panel.override_exp("Pick a predecessor Node")
	set_up()
	max_step_pre = 4
	current_algo = remove_after
	current_algo_b = remove_after_b
	prepare_signals_for_current()
