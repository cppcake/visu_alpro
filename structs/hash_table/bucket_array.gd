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

func insert(pair: HashKeyPair):
	var bucket_index = pair.hash_value % bucket_count
	bucket_index_history.append(bucket_index)
	var bucket: Bucket = get_child(bucket_index)
	bucket.insert_front(pair)
func insert_undo():
	var bucket: Bucket = get_child(bucket_index_history.pop_back())
	bucket.remove_front()

