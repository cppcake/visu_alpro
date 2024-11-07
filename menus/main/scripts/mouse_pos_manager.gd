extends Camera2D

var over_ui: bool

@export var zoom_level: float

# UI Margin for vertex, includes the width of a vertex (thats bad)
var upper_ui_margin: int = 100
var lower_ui_margin: int = 60
var left_ui_margin: int = 60
var right_ui_margin: int = 630

var viewport_pos: Vector2
var world_pos: Vector2
var init_drag_mouse_pos: Vector2

func _process(delta):
	world_pos = get_global_mouse_position()
	viewport_pos = get_viewport().get_mouse_position()
	
	drag_camera()
	zoom_camera(delta)
		
func drag_camera():
	if Input.is_action_just_pressed("M3"):
		init_drag_mouse_pos = viewport_pos
		return
		
	if Input.is_action_pressed("M3"):
		position += init_drag_mouse_pos - viewport_pos
		init_drag_mouse_pos = viewport_pos

var previous_zoom
func zoom_camera(delta):
	previous_zoom = zoom
	if is_over_playground():
		if Input.is_action_just_pressed("mouse_wheel_up"):
			if zoom.x < zoom_level:
				zoom += Vector2(5.0, 5.0) * delta

		if Input.is_action_just_pressed("mouse_wheel_down"):
			if zoom.x > 1.0/zoom_level:
				zoom -= Vector2(5.0, 5.0) * delta

	var zoom_factor = zoom / previous_zoom
	var diff_pos = (get_world_pos() - position) * (zoom_factor - Vector2(1, 1))
	position += diff_pos

func reset_zoom():
	zoom = Vector2(1.0, 1.0)

func is_over_playground() -> bool:
	return viewport_pos.y > upper_ui_margin - 60 && viewport_pos.x < get_viewport().get_visible_rect().size[0] - right_ui_margin + 60
	
func get_world_pos() -> Vector2:
	return world_pos
	
func get_viewport_pos() -> Vector2:
	return viewport_pos
