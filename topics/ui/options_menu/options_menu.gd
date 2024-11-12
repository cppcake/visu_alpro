extends CenterContainer

@export var vbox_content: VBoxContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_child(0).custom_minimum_size = Vector2(300, vbox_content.get_child_count() * 42)
	
	var esc = Input.is_action_just_pressed("ESC")
	if esc:
		visible = !visible
