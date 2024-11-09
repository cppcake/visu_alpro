extends Node

@export var head: pointer_class
var size: int = 0

@onready var list_v_scene = preload("res://graph/list_vertex.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var left_click = Input.is_action_just_pressed("M1")
	var right_click = Input.is_action_just_pressed("M2")
	var middle_click = Input.is_action_just_pressed("M3")

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
			
func backward():
	match current_algo:
		"insert_front_empty":
			insert_front_empty_b(current_step)
		"insert_front":
			insert_front_b(current_step)
	if current_step > 0:
		current_step = current_step - 1

func stop():
	while current_step < max_step:
		forward()
	current_step = 0
	max_step= 0
	current_algo = ""
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

func _on_button_insert_front_pressed():
	print("Size of list: " + str(size))
	current_step = 0
	if size == 0:
		max_step = 2
		current_algo = "insert_front_empty"
	else:
		max_step = 3
		current_algo = "insert_front"
		
