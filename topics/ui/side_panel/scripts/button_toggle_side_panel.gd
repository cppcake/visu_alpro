extends Button

var init_width: int

# Called when the node enters the scene tree for the first time.
func _ready():
	init_width = get_viewport().get_visible_rect().size[0] - get_parent().position.x


var degree_to: float = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation_degrees = lerp(float(rotation_degrees), degree_to, 10 * delta)
	
	var window_width: float = get_viewport().get_visible_rect().size[0]
	if open:
		get_parent().position.x = lerp(float(get_parent().position.x), float(window_width - init_width), 10 * delta)
	else:
		print(get_viewport().get_visible_rect().size)
		get_parent().position.x = lerp(float(get_parent().position.x), float(window_width), 10 * delta)

var open: bool = true
func _on_pressed():
	open = !open
	degree_to = 0

func _on_mouse_entered():
	if open:
		degree_to = 180

func _on_mouse_exited():
	degree_to = 0
