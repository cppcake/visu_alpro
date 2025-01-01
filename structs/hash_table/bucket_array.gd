class_name BucketArray
extends Node2D

@export var bucket_scene: PackedScene

var bucket_count: int = 0
var bucket_distance: int = 110

func _ready():
	for i: int in range(4):
		var bucket = bucket_scene.instantiate()
		bucket.global_position = Vector2(0, bucket_distance * bucket_count + 200)
		add_child(bucket)
		bucket.set_bucket_index(i)
		bucket_count += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var bucket_index_history := []
func clean_up():
	bucket_index_history = []
	for child in get_children():
		child.clean_up()

func reposition():
	for child in get_children():
		child.reposition()

func insert(pair: HashKeyPair):
	var bucket: Bucket = get_bucket(pair.hash_value % bucket_count)
	bucket.insert_front(pair)
func insert_undo():
	if bucket_index_history.is_empty():
		return
	var bucket: Bucket = get_child(bucket_index_history.pop_back())
	bucket.remove_front()

func remove(pair: HashKeyPair):
	var bucket: Bucket = get_bucket(pair.hash_value  % bucket_count)
	bucket.remove(pair.key)
func remove_undo():
	var bucket: Bucket = get_child(bucket_index_history.pop_back())
	bucket.remove_undo()

func get_bucket(bucket_index, save := true) -> Bucket:
	if save:
		bucket_index_history.append(bucket_index)
	
	return get_child(bucket_index)

func double_up():
	var bucket_count_before = bucket_count
	
	for i: int in range(bucket_count_before):
		var bucket = bucket_scene.instantiate()
		bucket.global_position = Vector2(0, bucket_distance * bucket_count + 200)
		add_child(bucket)
		bucket.set_bucket_index(i + bucket_count_before)
		bucket_count += 1
		
	for i: int in range(bucket_count_before):
		var current: pointer_class = get_bucket(i, false).head
		
		while current.target != null:
			var pair: HashKeyPair = current.target.hash_key_pair
			var hash_value = pair.hash_value
			if hash_value % bucket_count != i:
				get_bucket(i + bucket_count_before, false).insert_front(pair)
				get_bucket(i, false).remove_resize(pair.key)
			else:
				current = current.target.p1
func double_up_undo():
	var bucket_count_before = bucket_count / 2
	
	for i: int in range(bucket_count_before):
		get_bucket(i, false).remove_resize_undo()
		
	for i: int in range(bucket_count_before):
		get_bucket(i + bucket_count_before, false).queue_free()
	
	bucket_count = bucket_count_before

func half_down():
	var bucket_count_after = bucket_count / 2
	for i in range(bucket_count_after):
		var bucket: Bucket = get_bucket(i + bucket_count_after, false)
		var current: pointer_class = bucket.head
		
		while current.target != null:
			var vertex: HashVertex = current.target
			var hash_value = vertex.hash_key_pair.hash_value
			#print("The Hash %s, but the Mod is %s" % [hash_value, hash_value % bucket_count_after])
			get_bucket(hash_value % bucket_count_after).insert_front_resize(vertex.hash_key_pair)
			current = vertex.p1
			
		bucket.visible = false
		
	bucket_count = bucket_count_after
func half_down_undo():
	for i in range(bucket_count):
		var bucket: Bucket = get_bucket(i, false)
		bucket.insert_front_resize_undo()
			
		get_bucket(i + bucket_count, false).visible = true
		
	bucket_count *= 2
