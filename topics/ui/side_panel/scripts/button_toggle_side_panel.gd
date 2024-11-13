extends Button

var init_width: float
var rect_icon: TextureRect
func _ready():
	rect_icon = get_child(0)
	rect_icon.pivot_offset = size / 2
	init_width = float(get_viewport().get_visible_rect().size[0] - get_parent().position.x)
	get_parent().position.x = get_viewport().get_visible_rect().size[0]

var degree_to: float = 0
var inside: bool = false
func _process(delta):
	rect_icon.rotation_degrees = lerp(float(rect_icon.rotation_degrees), degree_to, 10 * delta)
	 
	if inside and !open:
		rect_icon.scale = lerp(rect_icon.scale, Vector2(1.4, 1.4), 10 * delta)
	else:
		rect_icon.scale = lerp(rect_icon.scale, Vector2(1.0, 1.0), 10 * delta)
	
	var window_width: float = get_viewport().get_visible_rect().size[0]
	var t: float = 10 * delta
	if open:
		pass
		get_parent().position.x = lerp(float(get_parent().position.x), window_width - init_width - 6, t)
	else:
		pass
		get_parent().position.x = lerp(float(get_parent().position.x), window_width + 6, t)

var open: bool = false
func _on_pressed():
	toggle_()

func toggle_():
	open = !open
	degree_to = 0

func open_():
	open = true
	degree_to = 0
	
func close_():
	open = false
	degree_to = 0

func force_open():
	open_()
	var window_width: float = get_viewport().get_visible_rect().size[0]
	get_parent().position.x = window_width - init_width - 6

func force_close():
	close_()
	var window_width: float = get_viewport().get_visible_rect().size[0]
	get_parent().position.x = window_width + 6

func _on_mouse_entered():
	inside = true
	if open:
		degree_to = 180

func _on_mouse_exited():
	inside = false
	degree_to = 0
