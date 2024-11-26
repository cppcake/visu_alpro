class_name CallStackContainer extends MarginContainer

@onready var stackframe_scene = preload("res://topics/ui/scenes/stackframe.tscn")
@export var call_stack: VBoxContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for child in call_stack.get_children():
		child.get_child(1).modulate = Color.WHITE
	
	if not stackframes.is_empty():
		stackframes.back().get_child(1).modulate = constants.color_1_c
	
	# Required for legacacy reasons
	var last_index: int = call_stack.get_child_count() - 1
	if last_index >= 0:
		call_stack.get_child(last_index).get_child(1).modulate = constants.color_1_c

var call_counter = 0
var stackframes = []
var removed_stackframes = []
func reset():
	call_counter = 0
	stackframes = []
	removed_stackframes = []
	for child in call_stack.get_children():
		child.queue_free()
func create_stackframe(stackframe_name: String):
	call_counter += 1
	var stackframe_instance = stackframe_scene.instantiate()
	stackframe_instance.get_child(1).get_child(0).text = stackframe_name + " (" + tr("CALL") + " " + str(call_counter) + ")"
	stackframes.append(stackframe_instance)
	call_stack.add_child(stackframe_instance)
func create_stackframe_undo():
	call_counter -= 1
	if not stackframes.is_empty():
		stackframes.pop_back().queue_free()

func remove_stackframe():
	removed_stackframes.append(stackframes.pop_back())
	removed_stackframes.back().visible = false
func remove_stackframe_undo():
	removed_stackframes.back().visible = true
	stackframes.append(removed_stackframes.pop_back())
# For legacy reasons this method is needed
func push_call_() -> Label:
	var stack_frame_instance = stackframe_scene.instantiate()
	call_stack.add_child(stack_frame_instance)
	return stack_frame_instance.get_child(1).get_child(0)
