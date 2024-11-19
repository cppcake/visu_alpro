class_name tree_traversal_class extends Node

@export var head: pointer_class
var size: int = 0

var list_v_scene
@export var side_panel: SidePanel
func _ready():
	list_v_scene = preload("res://structs/list/list_vertex.tscn")
	clean_up()

func _process(_delta):
	update_stack_frame()

var max_step_pre: int = 0
var current_algo: Callable
var current_algo_b: Callable
var current_step: int = 0
var max_step: int = 0
var crashed: bool = false
func forward():
	if current_step == max_step or crashed:
		return
		
	current_step = current_step + 1
	current_algo.call(current_step)
	
	update_step_label()

func backward():
	highlight_code_undo()
	if current_step == max_step:
		side_panel.override_code_return("")
	if current_step == 1:
		highlight_code([])
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
	
	reposition()

func cancel():
	while current_step > 0:
		backward()
	clean_up()
	reposition()

func clean_up():
	side_panel.close()
	
	current_step = 0
	max_step = 0
	new.set_target(null)
	new.visible = false
	make_current(null)
	update_step_label()
	
	side_panel.reset()
	side_panel.select_containers(0, 0, 0, 1)

func set_up(max_step_pre_: int, current_algo_: Callable, current_algo_b_, needs_current: bool = false):
	lines_history = []
	max_step_pre = max_step_pre_
	current_algo = current_algo_
	current_algo_b = current_algo_b_
	side_panel.open()
	
	if needs_current:
		prepare_signals_for_current()

func reposition():
	pass

@export var current: pointer_class
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

func init_algo():
	current_step = 0
	max_step = max_step_pre
	
	update_step_label()
	side_panel.select_containers(1, 0, 0, 1)
	side_panel.override_code_return("")
	current_algo.call(current_step)

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
			max_step = max_step_pre
			init_algo()
func prepare_signals_for_current() -> void:
	for child in self.get_children():
		if type_string(typeof(child)) == "Object":
			if child is list_vertex_class:
				if not child.is_connected("input_event", get_current_for_algo):
					child.connect("input_event", get_current_for_algo)

@export var new: pointer_class
var new_vertex: list_vertex_class
func make_shared(position_: Vector2, from: String = "left") -> list_vertex_class:
	var new_v = list_v_scene.instantiate()
	new_v.global_position = position_
	new_vertex = new_v
	add_child(new_v)	
	
	new.set_target(new_v)
	match from:
		"left":
			new.position = new_v.position + Vector2(-200, 0)
		"right":
			new.position = new_v.position + Vector2(200, 0)
		"above":
			new.position = new_v.position + Vector2(0, -200)
	new.current_end_point = new_v.position
	new.draw()
	new.visible = true
	
	return new_v
func unshare() -> void:
	new.visible = false
	new.position = Vector2(4200, 3900)
	new.set_target(null)
	new_vertex.queue_free()

var to_remove = null
func pseudo_remove():
	pass
func pseudo_remove_undo():
	pass

var lines_history = []
func highlight_code(lines):
	side_panel.highlight_code(lines)
	lines_history.append(lines)
func highlight_code_undo():
	lines_history.pop_back()

	if lines_history.size() >= 1:
		side_panel.highlight_code(lines_history.back())
	else:
		side_panel.highlight_code([])

func crash():
	side_panel.override_code_return("Segmentation fault (core dumped)", Color.RED)
	crashed = true
func uncrash():
	crashed = false
	side_panel.override_code_return("")
