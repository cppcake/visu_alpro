extends Node

@export var v2: doubly_list_vertex_class
@export var v3: doubly_list_vertex_class
@export var cam: CameraManager

# Called when the node enters the scene tree for the first time.
func _ready():
	v2.p1.set_target(v3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var left_click = Input.is_action_just_pressed("M1")
	var right_click = Input.is_action_just_pressed("M2")
	var middle_click = Input.is_action_just_pressed("M3")

	if left_click:
		v3.p2.set_target(v2)

	if right_click:
		v3.p2.set_target(null)

	if middle_click:
		pass
