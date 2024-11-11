extends Node

@export var head: pointer_class
var size: int = 0

@onready var list_v_scene = preload("res://graph/list_vertex.tscn")

var current_algo: Callable
var current_algo_b: Callable
var current_step: int = 0
var max_step: int = 0
func forward():
	if current_step == max_step:
		return
		
	current_step = current_step + 1
	current_algo.call(current_step)
	
	update_step_label()

func backward():
	if current_step == 0:
		return
		
	current_algo_b.call(current_step)
	current_step = current_step - 1
	
	update_step_label()

func finish():
	while current_step < max_step:
		forward()
	current_step = 0
	max_step= 0
	unshare(false)
	make_current(null)
	update_step_label()
	
	if to_remove != null:
		to_remove.queue_free()
	
	reposition_list()

func cancel():
	while current_step > 0:
		backward()
	current_step = 0
	max_step= 0
	unshare(false)
	make_current(null)
	update_step_label()
	reposition_list()

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
func update_size_label(addend: int):
	size = size + addend
	size_label.text = "size: " + str(size)

func init_algo(max_step_: int = max_step, current_algo_: Callable = current_algo, current_algo_b_: Callable = current_algo_b):
	print("Size of list: " + str(size))
	current_step = 0
	max_step = max_step_
	current_algo = current_algo_
	current_algo_b = current_algo_b_
	update_step_label()

var max_step_pre: int
func get_current_for_algo(_viewport, event, _shape_idx):
	# Check if the event is an InputEventMouseButton
	if event is InputEventMouseButton:
		# Check if it's a left-click (left mouse button has index 1)
		if event.button_index == 1 and event.pressed:
			while list_vertex_class.selected_vertex == null:
				pass
			make_current(list_vertex_class.selected_vertex)
			if(list_vertex_class.selected_vertex.p1.target == null):
				max_step = 1
			else:
				max_step = max_step_pre
			for child in self.get_children():
				if type_string(typeof(child)) == "Object":
					if child is list_vertex_class:
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

var new_vertex: list_vertex_class
var to_remove = null

func insert_front(step: int):
	match step:
		1:
			if head.target == null:
				make_shared(head.position + Vector2(0, 200))
			else:
				make_shared(head.position + Vector2(0, 325))
		2:
			new_vertex.p1.set_target(head.target)
		3:
			head.set_target(new_vertex)
		4:
			update_size_label(1)
func insert_front_b(step: int):
	match step:
		4:
			update_size_label(-1)
		3:
			head.set_target(new_vertex.p1.target)
		2:
			new_vertex.p1.set_target(null)
		1:
			unshare()
func _on_button_insert_front_pressed():
	init_algo(4, insert_front, insert_front_b)

func remove_front(step: int):
	match step:
		1:
			pass
		2:
			to_remove = head.target
			head.set_target(head.target.p1.target)
		3:
			pseudo_remove()
		4:
			update_size_label(-1)
func remove_front_b(step: int):
	match step:
		1:
			pass
		2:
			head.set_target(to_remove)
		3:
			pseudo_remove_undo()
		4:
			update_size_label(1)
func _on_button_remove_front_pressed():
	if size == 0:
		init_algo(1, remove_front, remove_front_b)
	else:
		init_algo(4, remove_front, remove_front_b)

func insert_after(step: int):
	var pred: list_vertex_class = list_vertex_class.selected_vertex
	match step:
		1:
			pass
		2:
			make_shared(pred.position + Vector2(125, -175), "above")
		3:
			new_vertex.p1.set_target(pred.p1.target)
		4:
			pred.p1.set_target(new_vertex)
		5:
			update_size_label(1)
func insert_after_b(step: int):
	var pred: list_vertex_class = list_vertex_class.selected_vertex
	match step:
		5:
			update_size_label(-1)
		4:
			pred.p1.set_target(new_vertex.p1.target)
		3:
			new_vertex.p1.set_target(null)
		2:
			unshare()
		1:
			pass
func _on_button_insert_after_pressed():
	prepare_signals_for_current()
	max_step_pre = 5
	current_algo = insert_after
	current_algo_b = insert_after_b

func remove_after(step: int):
	var pred: list_vertex_class = list_vertex_class.selected_vertex
	match step:
		1:
			pass
		2:
			to_remove = pred.p1.target
			if to_remove.p1.target != null:
				to_remove.move_to_rel(Vector2(0, 150))
			pred.p1.set_target(pred.p1.target.p1.target)
		3:
			pseudo_remove()
		4:
			update_size_label(-1)
func remove_after_b(step: int):
	var pred: list_vertex_class = list_vertex_class.selected_vertex
	match step:
		4:
			update_size_label(1)
		3:
			pseudo_remove_undo()
		2:
			if pred.p1.target != null:
				to_remove.move_to_rel(Vector2(0, -150))
			pred.p1.set_target(to_remove)
		1:
			pass
func _on_button_remove_after_pressed():
	prepare_signals_for_current()
	max_step_pre = 4
	current_algo = remove_after
	current_algo_b = remove_after_b
