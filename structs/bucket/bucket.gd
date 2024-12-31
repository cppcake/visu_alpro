extends Node2D

@export var head: pointer_class
@export var vertex_scene: PackedScene
@export var distance_vertices: int = 200
@export var insert_offset := Vector2(75, -75)

# Called when the node enters the scene tree for the first time.
func _ready():
	head.rel_null_end_point = Vector2(distance_vertices, 0)

func reposition():
	if head.target != null:
		var current_ = head.target
		var pos = head.position + Vector2(distance_vertices, 0)
		while current_ != null:
			current_.move_to(pos)
			pos += Vector2(distance_vertices, 0)
			current_ = current_.p1.target

func insert_front(data):
	var new_vertex: list_vertex_class = vertex_scene.instantiate()
	new_vertex.global_position = head.global_position + insert_offset
	add_child(new_vertex)
	
	new_vertex.set_data(data)
	
	new_vertex.p1.rel_null_end_point = Vector2(distance_vertices, 0)
	new_vertex.p1.set_target(head.target)
	head.set_target(new_vertex)
	reposition()
func remove_front():
	var to_remove = head.target
	head.set_target(head.target.p1.target)
	
	to_remove.p1.set_target(null)
	to_remove.queue_free()

	reposition()

func insert_at_index(data, index: int):
	var current = head
	
	while index > 0:
		current = current.target.p1
		index -= 1
	
	var new_vertex: list_vertex_class = vertex_scene.instantiate()
	new_vertex.global_position = current.global_position + insert_offset
	add_child(new_vertex)
	
	new_vertex.set_data(data)
	
	new_vertex.p1.rel_null_end_point = Vector2(distance_vertices, 0)
	new_vertex.p1.set_target(current.target)
	current.set_target(new_vertex)
	reposition()

var remove_history = []
func remove(data):
	var current = head
	var index = 0
	while current.target != null:
		if current.target.data == data:
			var to_remove = current.target
			current.set_target(current.target.p1.target)
			
			to_remove.p1.set_target(null)
			to_remove.queue_free()
			remove_history.append([data, index])
			
			reposition()
			return
		
		current = current.target.p1
		index += 1
func remove_undo():
	var data = remove_history.back()[0]
	var index = remove_history.pop_back()[1]
	insert_at_index(data, index)
