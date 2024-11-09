extends Node

@export var v: list_vertex_class
@export var v2: list_vertex_class
@export var v3: list_vertex_class
@export var cam: CameraManager

# Called when the node enters the scene tree for the first time.
func _ready():
	v.p1.target = v2
	v2.p1.target = v3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var left_click = Input.is_action_just_pressed("M1")
	var right_click = Input.is_action_just_pressed("M2")
	var middle_click = Input.is_action_just_pressed("M3")
	
	if left_click:
		v.move_to(cam.get_world_pos())
