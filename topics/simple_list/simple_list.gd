extends Node

@export var head: pointer_class
var size: int = 0

@onready var list_v_scene = preload("res://graph/list_vertex.tscn")

@export var label_progress: Label

var current_step: int = 0
var max_step: int = 0
var current_algo: String = ""
func forward():
	if current_step < max_step:
		current_step = current_step + 1
	match current_algo:
		"insert_front_empty":
			insert_front_empty(current_step)
		"insert_front":
			insert_front(current_step)
	update_state_counter()	

func backward():
	match current_algo:
		"insert_front_empty":
			insert_front_empty_b(current_step)
		"insert_front":
			insert_front_b(current_step)
	if current_step > 0:
		current_step = current_step - 1
	update_state_counter()

func stop():
	while current_step < max_step:
		forward()
	current_step = 0
	max_step= 0
	current_algo = ""
	update_state_counter()
	reposition_list()

var new_vertex: list_vertex_class
func insert_front(step: int):
	match step:
		1:
			new_vertex = list_v_scene.instantiate()
			new_vertex.position = head.position + Vector2(0, 200)
			
			add_child(new_vertex)
			size = size + 1
		2:
			if head.target == null:
				head.target = new_vertex
			else:
				new_vertex.p1.target = head.target
		3:
			head.target = new_vertex

func insert_front_b(step: int):
	match step:
		3:
			head.target = new_vertex.p1.target
		2:
			new_vertex.p1.target = null
		1:
			new_vertex.queue_free()
			size = size - 1

func insert_front_empty(step: int):
	match step:
		1:
			new_vertex = list_v_scene.instantiate()
			new_vertex.position = head.position + Vector2(0, 200)
			add_child(new_vertex)
			size = size + 1
		2:
			head.target = new_vertex

func insert_front_empty_b(step: int):
	match step:
		2:
			head.target = null
		1:
			new_vertex.queue_free()
			size = size - 1

func reposition_list():
	if head.target == null:
		head.position = Vector2(0, -75)
	else:
		var current = head.target
		var pos = head.position + Vector2(150, 75)
		while current != null:
			current.move_to(pos)
			pos += Vector2(200, 0)
			current = current.p1.target

func init_algo(max_step_: int, current_algo_: String):
	print("Size of list: " + str(size))
	current_step = 0
	max_step = max_step_
	current_algo = current_algo_
	update_state_counter()

func _on_button_insert_front_pressed():
	if size == 0:
		init_algo(2, "insert_front_empty")
	else:
		init_algo(3, "insert_front")
	update_state_counter()

func update_state_counter():
	label_progress.update_state_counter(current_step, max_step)
