extends operator_class

@export var bucket_array: BucketArray
@export var bucket_count_label: Label
@export var input_field: LineEdit

var hash_method: Callable
func hash_std(data):
	return hash(data)

func hash_weird(data):
	return int(data)

# Called when the node enters the scene tree for the first time.
func _ready():
	hash_method = Callable(self, "hash_weird")
	clean_up()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bucket_count_label.text = "bucket_count = " + str(bucket_array.bucket_count)

func clean_up():
	super.clean_up()
	bucket_array.clean_up()

func _on_button_insert_pressed():
	var input_string = input_field.get_text()
	input_field.clear()
	
	var pair = HashKeyPair.new(
					hash_method.call(input_string),
					input_string)
					
	bucket_array.insert(pair)


func _on_button_remove_pressed():
	var input_string = input_field.get_text()
	input_field.clear()
	
	var pair = HashKeyPair.new(
					hash_method.call(input_string),
					input_string)
					
	bucket_array.remove(pair)


var rng = RandomNumberGenerator.new()
func _on_button_search_pressed():
	var input_string = input_field.get_text()
	input_field.clear()
	
	var paiwr = HashKeyPair.new(
					hash_method.call(input_string),
					input_string)
	
	if true:
		for i in 30:
			var rand_string = str(int(rng.randf_range(0, 100.0)))
			
			var pair = HashKeyPair.new(
						hash_method.call(rand_string),
						rand_string)
						
			bucket_array.insert(pair)
	else:
		var ar = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
		for i in range(ar.size()):
			var rand_string = str(i)
			
			var pair = HashKeyPair.new(
						hash_method.call(rand_string),
						rand_string)
						
			bucket_array.insert(pair)

func _on_button_temp_pressed():
	bucket_array.double_up()

func _on_button_temp_2_pressed():
	bucket_array.double_up_undo()

func _on_button_temp_3_pressed():
	bucket_array.half_down()

func _on_button_temp_4_pressed():
	bucket_array.half_down_undo()
