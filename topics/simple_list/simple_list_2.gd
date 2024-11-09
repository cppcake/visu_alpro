extends Node

@export var head: pointer_class
var size: int = 0

@onready var list_v_scene = preload("res://graph/list_vertex.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var i = -1
func _process(delta):
	var left_click = Input.is_action_just_pressed("M1")
	var right_click = Input.is_action_just_pressed("M2")
	var middle_click = Input.is_action_just_pressed("M3")
	
	if left_click:
		i = i + 1
		insert_front(i)
	if right_click:
		insert_front_b(i)
		i = i -1

var new_vertex: list_vertex_class
func insert_front(step: int):
	match step:
		0:
			new_vertex = list_v_scene.instantiate()
			size = size + 1
			if head.target == null:
				new_vertex.position = head.position + Vector2(100, 100)
			add_child(new_vertex)
		1:
			if head.target == null:
				head.target = new_vertex
				
func insert_front_b(step: int):
	match step:
		1:
			if size == 1:
				head.target = null
		0:
			new_vertex.queue_free()
				
	
