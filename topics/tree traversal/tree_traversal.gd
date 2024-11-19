class_name tree_traversal_class extends Node

@export var root_ptr: pointer_class
@export var v1: tree_vertex_class
@export var v2: tree_vertex_class
@export var v3: tree_vertex_class
@export var v4: tree_vertex_class
@export var v5: tree_vertex_class
@export var v6: tree_vertex_class
@export var v7: tree_vertex_class
@export var cam: CameraManager

# Called when the node enters the scene tree for the first time.
func _ready():
	root_ptr.set_target(v1)
	v1.set_data(1)
	v2.set_data(2)
	v3.set_data(3)
	v4.set_data(4)
	v5.set_data(5)
	v6.set_data(6)
	v7.set_data(7)
	v1.p1.set_target(v2)
	v1.p2.set_target(v3)
	v2.p1.set_target(v4)
	v2.p2.set_target(v5)
	v3.p1.set_target(v6)
	v3.p2.set_target(v7)
	reposition_tree(root_ptr)

var offset_y: int = 180
var min_offset_x: int = 80
func reposition_tree(root: pointer_class):
	var width: int = int(pow(2, calculate_height(root_ptr))) * min_offset_x
	reposition_tree_(root, width)
func reposition_tree_(root: pointer_class, width: int):
	var root_vertex = root.target
	if root_vertex == null:
		return
	if root_vertex.dest_pos == null:
		root_vertex.dest_pos = root_vertex.global_position
	
	var left_child = root_vertex.p1.target
	if left_child != null:
		left_child.move_to(root_vertex.dest_pos + Vector2(-width, offset_y))
		reposition_tree_(root_vertex.p1, width / 2)
	
	var right_child = root_vertex.p2.target
	if right_child != null:
		right_child.move_to(root_vertex.dest_pos + Vector2(+width, offset_y))
		reposition_tree_(root_vertex.p2, width / 2)

func calculate_height(root: pointer_class) -> int:
	var root_vertex = root.target
	if root_vertex == null:
		return -1
	var height = 0
	
	var left_child = root_vertex.p1.target
	var left_height: int = 0
	if left_child != null:
		left_height = calculate_height(root_vertex.p1) + 1
	
	var right_child = root_vertex.p2.target
	var right_height: int = 0
	if right_child != null:
		right_height = calculate_height(root_vertex.p2) + 1
	
	if left_height > right_height:
		return height + left_height
	else:
		return height + right_height

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
