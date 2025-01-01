extends operator_class

@export var bucket_array: BucketArray
@export var bucket_count_label: Label
@export var occu_label: Label
@export var input_field: LineEdit

var hash_method: Callable
func hash_std(data):
	return hash(data)
func hash_weird(data):
	return int(data)

# Called when the node enters the scene tree for the first time.
func _ready():
	hash_method = Callable(self, "hash_std")
	clean_up()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bucket_count_label.text = "bucket_count = " + str(bucket_array.bucket_count)

#func reposition():
#	return
#	bucket_array.reposition()
func update_stack_frame():
	super.update_stack_frame()
	bucket_count_label.set_text("%s = %s" % [tr("BUCKET_COUNT"), str(bucket_array.bucket_count)])
	occu_label.set_text("%s = %s" % [tr("OCCU_FACT"), str(bel_fakt())])

func clean_up():
	super.clean_up()
	bucket_array.clean_up()

func operator_interface(operations: Array, undo: bool = false): 
	super.operator_interface(operations, undo)
	for operation: Operation in operations:
		var opcode = operation.opcode
		var argv = operation.argv
		match opcode:
			Operation.opcodes.HT_INSERT:
				if undo:
					bucket_array.insert_undo()
				else:
					bucket_array.insert(argv[0])
				continue
			Operation.opcodes.HT_REMOVE:
				if undo:
					bucket_array.remove_undo()
				else:
					bucket_array.remove(argv[0])
				continue
			Operation.opcodes.HT_DOUBLE_UP:
				if undo:
					bucket_array.double_up_undo()
				else:
					bucket_array.double_up()
				continue
			Operation.opcodes.HT_HALF_DOWN:
				if undo:
					bucket_array.half_down_undo()
				else:
					bucket_array.half_down()
				continue
			Operation.opcodes.HT_INC_SIZE:
				if undo:
					size -= 1
				else:
					size += 1
				update_stack_frame()
				continue
			Operation.opcodes.HT_DEC_SIZE:
				if undo:
					size += 1
				else:
					size -= 1
				update_stack_frame()
				continue
			Operation.opcodes.HT_REPOS:
				reposition()
				reposition()
				continue

func bel_fakt() -> float:
	return float(size) / float(bucket_array.bucket_count)

func insert(argv: Array = []):
	push_operations([
				Operation.new(
						Operation.opcodes.HIGHLIGHT_CODE,
						[[2]]),
				Operation.new(
						Operation.opcodes.OVERWRITE_VARIABLE,
						[0, tr("OCCU_FACT") + " = " + str(bel_fakt())]),
		])
	
	push_operations([
				Operation.new(
						Operation.opcodes.HIGHLIGHT_CODE,
						[[3]]),
		])
	if bel_fakt() > 0.75:
		push_operations([
			Operation.new(
						Operation.opcodes.HIGHLIGHT_CODE,
						[[4]]),
				Operation.new(
						Operation.opcodes.HT_DOUBLE_UP,
						[]),
		])
	
	var pair: HashKeyPair = argv[0]
	push_operations([
				Operation.new(
						Operation.opcodes.HIGHLIGHT_CODE,
						[[8]]),
				Operation.new(
						Operation.opcodes.OVERWRITE_VARIABLE,
						[1, "hash" + " = " + str(pair.hash_value)]),
		])
	push_operations([
				Operation.new(
						Operation.opcodes.HIGHLIGHT_CODE,
						[[9]]),
				Operation.new(
						Operation.opcodes.OVERWRITE_VARIABLE,
						[2, "bucket_index" + " = " + str(pair.hash_value % bucket_array.bucket_count)]),
		])
	
	push_operations([
			Operation.new(
						Operation.opcodes.HIGHLIGHT_CODE,
						[[12]]),
			Operation.new(
					Operation.opcodes.HT_INSERT,
					[pair]),
			Operation.new(
					Operation.opcodes.HT_INC_SIZE,
					[]),
		])
	
	push_operations([
			Operation.new(
						Operation.opcodes.HIGHLIGHT_CODE,
						[[13]]),
		])
	
	push_operations([
			Operation.new(
						Operation.opcodes.HIGHLIGHT_CODE,
						[[]]),
			Operation.new(
					Operation.opcodes.OVERWRITE_RETURN,
					[null]),
		])
func _on_button_insert_pressed():
	var input_string = input_field.get_text()
	input_field.clear()
	
	side_panel.create_variable()
	side_panel.create_variable()
	side_panel.create_variable()
	side_panel.override_code(tr("HT_INS"))
	side_panel.select_containers(1, 1, 0, 0)
	side_panel.override_code_call("hashtable.insert(" + input_string + ")")
	side_panel.open()
	
	var pair = HashKeyPair.new(
					hash_method.call(input_string),
					input_string)
	init_algo(insert, [pair])

func remove(argv: Array = []):
	push_operations([
				Operation.new(
						Operation.opcodes.HIGHLIGHT_CODE,
						[[2]]),
				Operation.new(
						Operation.opcodes.OVERWRITE_VARIABLE,
						[0, tr("OCCU_FACT") + " = " + str(bel_fakt())]),
		])
		
	push_operations([
				Operation.new(
						Operation.opcodes.HIGHLIGHT_CODE,
						[[3]]),
		])
	if bel_fakt() < 0.25 and bucket_array.bucket_count > 1:
		push_operations([
			Operation.new(
						Operation.opcodes.HIGHLIGHT_CODE,
						[[4]]),
				Operation.new(
						Operation.opcodes.HT_HALF_DOWN,
						[]),
		])
	
	var pair: HashKeyPair = argv[0]
	push_operations([
				Operation.new(
						Operation.opcodes.HIGHLIGHT_CODE,
						[[8]]),
				Operation.new(
						Operation.opcodes.OVERWRITE_VARIABLE,
						[1, "hash" + " = " + str(pair.hash_value)]),
		])
	push_operations([
				Operation.new(
						Operation.opcodes.HIGHLIGHT_CODE,
						[[9]]),
				Operation.new(
						Operation.opcodes.OVERWRITE_VARIABLE,
						[2, "bucket_index" + " = " + str(pair.hash_value % bucket_array.bucket_count)]),
		])
	
	push_operations([
				Operation.new(
						Operation.opcodes.HIGHLIGHT_CODE,
						[[12]]),
		])
	if bucket_array.search(pair):
		push_operations([
				Operation.new(
						Operation.opcodes.HIGHLIGHT_CODE,
						[[12]]),
				Operation.new(
						Operation.opcodes.HT_REMOVE,
						[pair]),
			])
		
		push_operations([
				Operation.new(
							Operation.opcodes.HIGHLIGHT_CODE,
							[[14]]),
				Operation.new(
						Operation.opcodes.HT_DEC_SIZE,
						[]),
			])

	push_operations([
			Operation.new(
						Operation.opcodes.HIGHLIGHT_CODE,
						[[]]),
			Operation.new(
					Operation.opcodes.OVERWRITE_RETURN,
					[null]),
		])

func _on_button_remove_pressed():
	var input_string = input_field.get_text()
	input_field.clear()
	
	side_panel.create_variable()
	side_panel.create_variable()
	side_panel.create_variable()
	side_panel.override_code(tr("HT_RM"))
	side_panel.select_containers(1, 1, 0, 0)
	side_panel.override_code_call("hashtable.remove(" + input_string + ")")
	side_panel.open()
	
	var pair = HashKeyPair.new(
					hash_method.call(input_string),
					input_string)
	init_algo(remove, [pair])

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
