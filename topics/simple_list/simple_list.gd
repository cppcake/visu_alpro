extends Node

@export var head: pointer_class
@export var current: pointer_class
var size: int = 0

@onready var list_v_scene = preload("res://graph/list_vertex.tscn")

func _ready():
	make_current(null)

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

func stop():
	while current_step < max_step:
		forward()
	current_step = 0
	max_step= 0
	update_step_label()
	make_current(null)
	reposition_list()
	
	if to_remove != null:
		to_remove.queue_free()

func reposition_list():
	if head.target == null:
		head.position = Vector2(0, 0)
	else:
		var current_ = head.target
		var pos = head.position + Vector2(150, 150)
		while current_ != null:
			current_.move_to(pos)
			pos += Vector2(200, 0)
			current_ = current_.p1.target
	
func make_current(target):
	if target == null:
		current.visible = false
		current.set_target(null)
		current.position = Vector2(9000, 9000)
	else:
		current.set_target(target)
		current.position = target.position + Vector2(0, -200)
		current.current_end_point = target.position
		current.visible = true	

@export var label_progress: Label
func update_step_label():
	label_progress.update_step_label(current_step, max_step)

@export var size_label: Label
func update_size_label(addend: int):
	size = size + addend
	size_label.text = "List size: " + str(size)

func init_algo(max_step_: int, current_algo_: Callable, current_algo_b_: Callable):
	print("Size of list: " + str(size))
	current_step = 0
	max_step = max_step_
	current_algo = current_algo_
	current_algo_b = current_algo_b_
	update_step_label()

var new_vertex: list_vertex_class
func insert_front(step: int):
	match step:
		1:
			new_vertex = list_v_scene.instantiate()
			new_vertex.position = head.position + Vector2(0, 200)
			add_child(new_vertex)
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
			new_vertex.queue_free()

var to_remove = null
func remove_front(step: int):
	match step:
		1:
			pass
		2:
			to_remove = head.target
			head.set_target(head.target.p1.target)
		3:
			to_remove.visible = false
		4:
			update_size_label(-1)

func remove_front_b(step: int):
	match step:
		1:
			pass
		2:
			head.set_target(to_remove)
		3:
			to_remove.visible = true
		4:
			update_size_label(1)

func _on_button_insert_front_pressed():
	init_algo(4, insert_front, insert_front_b)

func _on_button_remove_front_pressed():
	if size == 0:
		init_algo(1, remove_front, remove_front_b)
	else:
		init_algo(4, remove_front, remove_front_b)

func prepare_insert_after(_viewport, event, _shape_idx):
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
						child.disconnect("input_event", prepare_insert_after)

func _on_button_insert_after_pressed():
	for child in self.get_children():
		if type_string(typeof(child)) == "Object":
			if child is list_vertex_class:
				child.connect("input_event", prepare_insert_after)

func _on_button_remove_after_pressed():
	pass # Replace with function body.
