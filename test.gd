extends Node

@export var v1: list_vertex_class
@export var v2: list_vertex_class
@export var v3: list_vertex_class
@export var cam: CameraManager

# Called when the node enters the scene tree for the first time.
func _ready():
	v1.p1.set_target(v2)
	v2.p1.set_target(v3)
	v3.p1.set_target(v1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var left_click = Input.is_action_just_pressed("M1")
	var right_click = Input.is_action_just_pressed("M2")
	var middle_click = Input.is_action_just_pressed("M3")

	if left_click:
		pass

	if right_click:
		pass

	if middle_click:
		pass
