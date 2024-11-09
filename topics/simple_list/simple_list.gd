extends Node

@export var head: pointer_class
var size: int = 0

@onready var list_v_scene = preload("res://graph/list_vertex.tscn")

@export var label_progress: Label

var current_step: int = 0
var max_step: int = 0
var current_algo: String = ""
func forward():
	if current_step == max_step:
		return
		
	current_step = current_step + 1
	match current_algo:
		"insert_front":
			insert_front(current_step)
		"remove_front":
			remove_front(current_step)
	
	update_step_label()

func backward():
	if current_step == 0:
		return
		
	match current_algo:
		"insert_front":
			insert_front_b(current_step)
		"remove_front":
			remove_front_b(current_step)
	current_step = current_step - 1
	
	update_step_label()

func stop():
	while current_step < max_step:
		forward()
	current_step = 0
	max_step= 0
	current_algo = ""
	update_step_label()
	reposition_list()
	
	if to_remove != null:
		to_remove.queue_free()

var new_vertex: list_vertex_class
func insert_front(step: int):
	match step:
		1:
			new_vertex = list_v_scene.instantiate()
			new_vertex.position = head.position + Vector2(0, 200)
			add_child(new_vertex)
		2:
			new_vertex.p1.target = head.target
		3:
			head.target = new_vertex
		4:
			update_size_label(1)

func insert_front_b(step: int):
	match step:
		4:
			update_size_label(-1)
		3:
			head.target = new_vertex.p1.target
		2:
			new_vertex.p1.target = null
		1:
			new_vertex.queue_free()

var to_remove = null
func remove_front(step: int):
	match step:
		1:
			pass
		2:
			to_remove = head.target
			to_remove.visible = false
			
			head.target = head.target.p1.target
		3:
			update_size_label(-1)

func remove_front_b(step: int):
	match step:
		1:
			pass
		2:
			head.target = to_remove
			to_remove.visible = true
		3:
			update_size_label(1)

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

func update_step_label():
	label_progress.update_step_label(current_step, max_step)

@export var size_label: Label
func update_size_label(addend: int):
	size = size + addend
	size_label.text = "List size: " + str(size)
	
func init_algo(max_step_: int, current_algo_: String):
	print("Size of list: " + str(size))
	current_step = 0
	max_step = max_step_
	current_algo = current_algo_
	update_step_label()

func _on_button_insert_front_pressed():
	init_algo(4, "insert_front")

func _on_button_remove_front_pressed():
	if size == 0:
		init_algo(1, "remove_front")
	else:
		init_algo(3, "remove_front")


