extends Node

@export var v1: tree_vertex_class
@export var v2: tree_vertex_class
@export var v3: tree_vertex_class
@export var cam: CameraManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

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
