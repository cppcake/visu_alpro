extends CheckButton

var cur: bool = false
func _ready():
	var config = ConfigFile.new()
	config.load("user://config.cfg")
	
	if config.has_section("display"):
		match config.get_value("display", "fullscreen"):
			true:
				button_pressed = true
				_on_toggled(true)
				cur = true
			false:
				button_pressed = false
				_on_toggled(false)

func _process(_delta):
	var f11 = Input.is_action_just_pressed("F11")
	if f11:
		_on_toggled(!cur)

func _on_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

	button_pressed = toggled_on
	cur = toggled_on
	var config = ConfigFile.new()
	config.load("user://config.cfg")
	config.set_value("display", "fullscreen", toggled_on)
	config.save("user://config.cfg")
