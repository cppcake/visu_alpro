class_name CallStackContainer extends MarginContainer

@onready var stack_frame_scene = preload("res://topics/ui/scenes/stack_frame.tscn")
@export var call_stack: VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if false:
		for child in call_stack.get_children():
			if not child is stackframe:
				child.get_child(1).modulate = Color.WHITE
		
		var last_index: int = call_stack.get_child_count() - 1
		if last_index >= 0:
			if not call_stack.get_child(last_index).get_child(1) is stackframe:
				pass#call_stack.get_child(last_index).get_child(1).modulate = constants.color_1_c

var stack_size: int = 0
func reset():
	stack_size = 0
	for child in call_stack.get_children():
		child.queue_free()

func push_call_() -> Label:
	stack_size += 1
	var stack_frame_instance = stack_frame_scene.instantiate()
	if stack_size == 1:
		stack_frame_instance.get_child(0).visible = true
	call_stack.add_child(stack_frame_instance)
	return stack_frame_instance.get_child(1)
	
func pop_cal():
	pass


@onready var stackframe_scene = preload("res://topics/ui/scenes/stackframe.tscn")

var stackframes: Array = []
func make_call():
	var stackframe_instance = stackframe_scene.instantiate()
	stackframes.append(stackframe_instance)
	call_stack.add_child(stackframe_instance)
	create_variable("variable_name: String")
func make_call_undo():
	var stackframe_instance = stackframes.pop_back()
	stackframe_instance.queue_free()

func create_variable(variable_name: String):
	stackframes[-1].create_variable(variable_name)
func create_variable_undo():
	stackframes[-1].create_variable_undo()
