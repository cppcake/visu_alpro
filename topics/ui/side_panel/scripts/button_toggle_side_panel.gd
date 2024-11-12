extends Button

var init_width: int
var rect_icon: TextureRect
func _ready():
	rect_icon = get_child(0)
	rect_icon.pivot_offset = size / 2
	init_width = get_viewport().get_visible_rect().size[0] - get_parent().position.x

var degree_to: float = 0
var inside: bool = false
func _process(delta):
	rect_icon.rotation_degrees = lerp(float(rect_icon.rotation_degrees), degree_to, 10 * delta)
	 
	if inside and !open:
		rect_icon.scale = lerp(rect_icon.scale, Vector2(1.4, 1.4), 10 * delta)
	else:
		rect_icon.scale = lerp(rect_icon.scale, Vector2(1.0, 1.0), 10 * delta)
	
	var window_width: float = get_viewport().get_visible_rect().size[0]
	if open:
		get_parent().position.x = lerp(float(get_parent().position.x), float(window_width - init_width), 10 * delta)
	else:
		get_parent().position.x = lerp(float(get_parent().position.x), float(window_width) + 4.0, 10 * delta)

var open: bool = true
func _on_pressed():
	open = !open
	degree_to = 0

func _on_mouse_entered():
	inside = true
	if open:
		degree_to = 180

func _on_mouse_exited():
	inside = false
	degree_to = 0
