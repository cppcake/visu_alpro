class_name list_vertex_class extends Area2D

# Static variables and functions
static var lerp_speed: int = 15;

# Visuals of vertex 
var sprite: Sprite2D
var label_data: Label
var label_ref_count: Label
var p1: pointer_class

# Animation
var dest_pos

func _ready():
	sprite = get_child(1)
	label_data = get_child(2)
	label_ref_count = get_child(3)
	p1 = get_child(4)
	p1.current_end_point = global_position + Vector2(0, 150)
	p1.draw()
	p1.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if dest_pos != null:
		global_position = lerp(global_position, dest_pos, lerp_speed * delta)

var reference_counter: int = 0
@export var sprite_default: CompressedTexture2D
@export var sprite_to_remove: CompressedTexture2D
func _process(_delta):
	# Not efficient i dont care
	if reference_counter >= 1:
			sprite.texture = sprite_default
			label_ref_count.add_theme_color_override("font_color", Color.WHITE)
	else:
			sprite.texture = sprite_to_remove
			label_ref_count.add_theme_color_override("font_color", Color.WEB_MAROON)
	
	label_ref_count.text = str(reference_counter)

func move_to(dest_pos_: Vector2):
	if dest_pos != null:
		global_position = dest_pos
	dest_pos = dest_pos_

func move_to_rel(offset: Vector2):
	move_to(position + offset)

func _on_mouse_entered():
	modulate = constants.hovered

func _on_mouse_exited():
	modulate = Color(1.0, 1.0, 1.0, 1.0)

static var selected_vertex = null
func _on_input_event(_viewport, event, _shape_idx):
	# Check if the event is an InputEventMouseButton
	if event is InputEventMouseButton:
		# Check if it's a left-click (left mouse button has index 1)
		if event.button_index == 1 and event.pressed:
			selected_vertex = self
