class_name operator_class extends Node

@export var vertex_scene: PackedScene

func create_new_vertex(position_: Vector2, from: String = "left") -> list_vertex_class:
	var new_vertex = vertex_scene.instantiate()
	new_vertex.global_position = position_
	add_child(new_vertex)
	
	new_ptr.set_target(new_vertex)
	match from:
		"left":
			new_ptr.position = new_vertex.position + Vector2(-200, 0)
		"right":
			new_ptr.position = new_vertex.position + Vector2(200, 0)
		"above":
			new_ptr.position = new_vertex.position + Vector2(0, -200)
	
	new_ptr.current_end_point = new_vertex.position
	new_ptr.draw()
	new_ptr.visible = true
	
	return new_vertex
func create_new_vertex_undo(new_vertex: list_vertex_class):
	new_ptr.visible = false
	new_ptr.set_target(null)
	new_vertex.queue_free()

@export var new_ptr: pointer_class
func make_shared(new_vertex):
	new_vertex.visible = true
	new_ptr.visible = true
func make_shared_undo(new_vertex: list_vertex_class):
	new_ptr.visible = false
	new_vertex.visible = false

func point_at(pointer: pointer_class, target):
	pointer.set_target(target)
func point_at_undo(pointer: pointer_class):
	pointer.set_target_undo()

var target_before
var to_remove = null
func pseudo_remove() -> void:
	to_remove.visible = false
	target_before = to_remove.p1.target
	to_remove.p1.set_target(null)
func pseudo_remove_undo() -> void:
	to_remove.p1.set_target(target_before)
	if target_before != null:
		to_remove.p1.current_end_point = target_before.global_position
		to_remove.p1.draw()
	to_remove.visible = true

func clean_up():
	new_ptr.set_target(null)
	new_ptr.visible = false

func swap(vertex_1: tree_vertex_class, vertex_2: tree_vertex_class) -> void:
	var buf: int = vertex_1.data
	vertex_1.set_data(vertex_2.data)
	vertex_2.set_data(buf)
