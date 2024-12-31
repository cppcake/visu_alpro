extends operator_class

@export var bucket_array: BucketArray
@export var input_field: LineEdit

var hash_method: Callable
func hash_std(data):
	return hash(data)

# Called when the node enters the scene tree for the first time.
func _ready():
	hash_method = Callable(self, "hash_std")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_insert_pressed():
	current_step = 0
	var input_string = input_field.get_text()
	input_field.clear()
	
	var pair = HashKeyPair.new(
					hash_method.call(input_string),
					input_string)
					
	bucket_array.insert(pair)
