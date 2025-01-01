class_name Bucket
extends Node2D

@export var head: pointer_class
@export var vertex_scene: PackedScene
@export var distance_vertices: int = 200
@export var insert_offset := Vector2(100, 0)

@export var label_index: Label
var bucket_index: int

# Called when the node enters the scene tree for the first time.
func _ready():
	head.rel_null_end_point = Vector2(distance_vertices, 0)

# Helper functions
func set_bucket_index(index_):
	bucket_index = index_
	label_index.set_text(str(bucket_index))
func insert_at_index(pair, index: int):
	var current = head
	
	while index > 0:
		current = current.target.p1
		index -= 1
	
	var new_vertex: HashVertex = vertex_scene.instantiate()
	new_vertex.move_to(current.global_position + insert_offset)
	add_child(new_vertex)
	
	new_vertex.set_hash_key_pair(pair)
	
	new_vertex.p1.rel_null_end_point = Vector2(distance_vertices, 0)
	new_vertex.p1.set_target(current.target)
	current.set_target(new_vertex)
	reposition()
func reposition():
	if head.target != null:
		var current = head.target
		var pos = global_position + Vector2(distance_vertices, 0)
		while current != null:
			current.move_to(pos)
			pos += Vector2(distance_vertices, 0)
			current = current.p1.target
func clean_up():
	remove_history.clear()
	remove_history_resize.clear()
	insert_counter = 0

func search(pair: HashKeyPair)-> bool:
	var current = head
	while current.target != null:
		if current.target.hash_key_pair.key == pair.key:
			return true
		current = current.target.p1
			
	return false

# Operations
func insert_front(pair: HashKeyPair):
	var new_vertex: HashVertex = vertex_scene.instantiate()
	new_vertex.move_to(global_position + insert_offset)
	add_child(new_vertex)
	
	new_vertex.set_hash_key_pair(pair)
	
	new_vertex.p1.rel_null_end_point = Vector2(distance_vertices - 50, 0)
	new_vertex.p1.set_target(head.target)
	head.set_target(new_vertex)
	reposition()
func remove_front():
	var to_remove = head.target
	head.set_target(head.target.p1.target)
	
	to_remove.p1.set_target(null)
	to_remove.queue_free()

	reposition()
	reposition()

var remove_history = []
func remove(key: String):
	var current = head
	var index = 0
	while current.target != null:
		if current.target.hash_key_pair.key == key:
			var to_remove: HashVertex = current.target
			current.set_target(current.target.p1.target)
			
			remove_history.append(
					[to_remove.hash_key_pair,
					index])
			to_remove.p1.set_target(null)
			to_remove.queue_free()
			
			reposition()
			return
		
		current = current.target.p1
		index += 1
func remove_undo():
	var data = remove_history.back()[0]
	var index = remove_history.pop_back()[1]
	insert_at_index(data, index)

var insert_counter = 0
func insert_front_resize(pair: HashKeyPair):
	insert_counter += 1
	insert_front(pair)
func insert_front_resize_undo():
	for i in range(insert_counter):
		remove_front()
	insert_counter = 0

var remove_history_resize = []
func remove_resize(key: String):
	var current = head
	var index = 0
	while current.target != null:
		if current.target.hash_key_pair.key == key:
			var to_remove: HashVertex = current.target
			current.set_target(current.target.p1.target)
			
			remove_history_resize.append(
					[to_remove.hash_key_pair,
					index])
			to_remove.p1.set_target(null)
			to_remove.queue_free()
			
			reposition()
			return
		
		current = current.target.p1
		index += 1
func remove_resize_undo():
	while not remove_history_resize.is_empty():
		var data = remove_history_resize.back()[0]
		var index = remove_history_resize.pop_back()[1]
		insert_at_index(data, index)
