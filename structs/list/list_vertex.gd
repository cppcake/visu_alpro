class_name list_vertex_class extends anim_node

enum sprites
{
	DEFAULT,
	ACCENT,
	TO_REMOVE
}

# Visuals of vertex 
var sprite: Sprite2D
@export var sprite_default: CompressedTexture2D
@export var sprite_accent: CompressedTexture2D
@export var sprite_to_remove: CompressedTexture2D
var label_data: Label
var label_ref_count: Label
var p1: pointer_class

func _ready():
	sprite = get_child(1)
	label_data = get_child(2)
	label_ref_count = get_child(3)
	p1 = get_child(4)
	p1.current_end_point = global_position + Vector2(0, 150)
	p1.draw()
	p1.visible = true

var reference_counter: int = 0
func update_reference_counter(addend: int):
	reference_counter += addend
	if reference_counter >= 1:
		set_sprite(sprites.DEFAULT)
	else:
		set_sprite(sprites.TO_REMOVE)
	label_ref_count.text = str(reference_counter)

var sprite_history: Array = [sprites.DEFAULT]
func set_sprite(selection: sprites):
	sprite_history.push_back(selection)
	match selection:
		sprites.DEFAULT:
			sprite.texture = sprite_default
			label_ref_count.add_theme_color_override("font_color", Color.WHITE)
		sprites.ACCENT:
			sprite.texture = sprite_accent
			label_ref_count.add_theme_color_override("font_color", Color.WHITE)
		sprites.TO_REMOVE:
			sprite.texture = sprite_to_remove
			label_ref_count.add_theme_color_override("font_color", Color.WEB_MAROON)
func set_sprite_undo():
	sprite_history.pop_back()
	set_sprite(sprite_history.back())

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
