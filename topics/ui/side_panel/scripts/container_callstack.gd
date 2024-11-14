class_name CallStackContainer extends MarginContainer

@onready var stack_frame_scene = preload("res://topics/ui/scenes/stack_frame.tscn")
@export var call_stack: VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for child in call_stack.get_children():
		child.get_child(1).modulate = Color.WHITE
	
	var last_index: int = call_stack.get_child_count() - 1
	if last_index >= 0:
		call_stack.get_child(last_index).get_child(1).modulate = constants.color_1_c
	
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
