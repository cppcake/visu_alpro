extends operator_class

@export var bucket_array: BucketArray
@export var bucket_count_label: Label
@export var occu_label: Label
@export var input_field: LineEdit

var hash_method: Callable
func hash_sha256(text: String):
	return abs(text.sha256_buffer().decode_u64(0))
func hash_01(text: String):
	return abs(text.length())
func hash_02(text: String):
	if text.is_empty():
		return 0
	else:
		return abs(text.to_ascii_buffer().decode_u8(0))
func hash_03(text: String):
	var sum = 0
	
	if text.is_empty():
		return 0
	
	for char_ in text:
		sum += char_.to_ascii_buffer().decode_u8(0)
	
	return abs(int(sum / text.length()))
func hash_04(text: String):
	var sum = 0
	
	for char_ in text:
		sum += char_.to_ascii_buffer().decode_u8(0)
	
	return abs(int(sum % int(pow(2, 64))))

# Called when the node enters the scene tree for the first time.
func _ready():
	tutorial()
	hash_method = Callable(self, "hash_sha256")

func update_stack_frame():
	super.update_stack_frame()
	bucket_count_label.set_text("%s = %s" % [tr("BUK_CONT"), str(bucket_array.bucket_count)])
	occu_label.set_text("%s = %s" % [tr("OCCU_FACT"), str(bel_fakt())])
func reset():
	bucket_array.reset()
	size = 0
	update_stack_frame()
	clean_up()
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
		])
	
	push_operations([
			Operation.new(
						Operation.opcodes.HIGHLIGHT_CODE,
						[[13]]),
			Operation.new(
					Operation.opcodes.HT_INC_SIZE,
					[]),
		])
	
	push_operations([
			Operation.new(
						Operation.opcodes.HIGHLIGHT_CODE,
						[[15]]),
			Operation.new(
					Operation.opcodes.OVERWRITE_RETURN,
					[null]),
		])
func insert_many(argv: Array = []):
	for input: String in argv[0]:
		if bel_fakt() > 0.75:
			push_operations([
					Operation.new(
							Operation.opcodes.HT_DOUBLE_UP,
							[]),
			])
			
		var pair = HashKeyPair.new(
					hash_method.call(input),
					input)
		push_operations([
			Operation.new(
					Operation.opcodes.HT_INSERT,
					[pair]),
			Operation.new(
					Operation.opcodes.HT_INC_SIZE,
					[]),
		])
func _on_button_insert_pressed():
	var input_string = input_field.get_text()
	input_field.clear()
	
	var inputs: Array = input_string.split(",")
	if inputs.size() > 1:
		side_panel.close()
		side_panel.override_code(tr("HT_RM"))
		side_panel.override_code_call("hashtable.insert(" + str(inputs) + ")")
		side_panel.select_containers(1, 0, 0, 0)
		init_algo(insert_many, [inputs])
		return
	
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
						[[17]]),
			Operation.new(
					Operation.opcodes.OVERWRITE_RETURN,
					[null]),
		])
func remove_many(argv: Array = []):
	var inputs: Array = []#input_string.split(",")
	if inputs.size() > 1:
		side_panel.override_code(tr("HT_RM"))
		side_panel.override_code_call("hashtable.remove(" + str(inputs) + ")")
		side_panel.select_containers(1, 0, 0, 0)
		init_algo(remove_many, [inputs])
		side_panel.close()
		return
	for input in argv[0]:
		if bel_fakt() < 0.25 and bucket_array.bucket_count > 1:
			push_operations([
					Operation.new(
							Operation.opcodes.HT_HALF_DOWN,
							[]),
			])
		var pair = HashKeyPair.new(
					hash_method.call(input),
					input)

		if bucket_array.search(pair):
			push_operations([
					Operation.new(
							Operation.opcodes.HT_REMOVE,
							[pair]),
					Operation.new(
							Operation.opcodes.HT_DEC_SIZE,
							[]),
				])
func _on_button_remove_pressed():
	var input_string = input_field.get_text()
	input_field.clear()
	
	side_panel.override_code(tr("HT_RM"))
	side_panel.create_variable()
	side_panel.create_variable()
	side_panel.create_variable()
	side_panel.select_containers(1, 1, 0, 0)
	side_panel.override_code_call("hashtable.remove(" + input_string + ")")
	side_panel.open()
	
	var pair = HashKeyPair.new(
					hash_method.call(input_string),
					input_string)
	init_algo(remove, [pair])

func _on_button_search_pressed():
	pass

func _on_button_reset_pressed():
	reset()

func _on_option_button_hash_item_selected(index):
	reset()
	
	match index:
		0:
			hash_method = Callable(self, "hash_sha256")
			return
		1:
			hash_method = Callable(self, "hash_01")
			return
		2:
			hash_method = Callable(self, "hash_02")
			return
		3:
			hash_method = Callable(self, "hash_03")
			return
		4:
			hash_method = Callable(self, "hash_04")
			return
