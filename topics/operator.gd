extends Node

@export var vertex_scene: PackedScene

@export var new_ptr: pointer_class
var new_vertex: list_vertex_class
func make_shared(position_: Vector2, from: String = "left") -> list_vertex_class:
	var new_v = vertex_scene.instantiate()
	new_v.global_position = position_
	new_vertex = new_v
	add_child(new_v)
	
	new_ptr.set_target(new_v)
	match from:
		"left":
			new_ptr.position = new_v.position + Vector2(-200, 0)
		"right":
			new_ptr.position = new_v.position + Vector2(200, 0)
		"above":
			new_ptr.position = new_v.position + Vector2(0, -200)
	new_ptr.current_end_point = new_v.position
	new_ptr.draw()
	new_ptr.visible = true
	
	return new_v
func make_shared_undo():
	new_ptr.visible = false
	new_ptr.position = Vector2(4200, 3900)
	new_ptr.set_target(null)
	new_vertex.queue_free()
	
func point_at(pointer: pointer_class, target):
	pointer.set_target(target)
func point_at_undo(pointer: pointer_class):
	pointer.set_target_undo()

func pseudo_remove(vertex):
	pass
	
func pseudo_remove_undo(vertex):
	pass
	
func swap(vertex_1, swap_2):
	pass
