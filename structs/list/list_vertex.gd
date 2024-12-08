class_name list_vertex_class extends anim_node

enum sprites
{
	DEFAULT,
	ACCENT,
	ACCENT_2,
	TO_REMOVE
}

# Visuals of vertex 
@export var sprite: Sprite2D
@export var sprite_default: CompressedTexture2D
@export var sprite_accent: CompressedTexture2D
@export var sprite_accent_2: CompressedTexture2D
@export var sprite_to_remove: CompressedTexture2D
@export var label_tag: Label
@export var label_data: Label
@export var label_ref_count: Label
@export var p1: pointer_class

func _ready():
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
func set_sprite(selection: sprites, save: bool = true):
	if save:
		sprite_history.push_back(selection)
	match selection:
		sprites.DEFAULT:
			sprite.texture = sprite_default
			label_ref_count.add_theme_color_override("font_color", Color.WHITE)
		sprites.ACCENT:
			sprite.texture = sprite_accent
			label_ref_count.add_theme_color_override("font_color", Color.WHITE)
		sprites.ACCENT_2:
			sprite.texture = sprite_accent_2
			label_ref_count.add_theme_color_override("font_color", Color.WHITE)
		sprites.TO_REMOVE:
			sprite.texture = sprite_to_remove
			label_ref_count.add_theme_color_override("font_color", Color.WEB_MAROON)
func set_sprite_undo():
	sprite_history.pop_back()
	set_sprite(sprite_history.back(), false)
func reset_visuals():
	set_sprite(sprites.DEFAULT)
	sprite_history = [sprites.DEFAULT]
	set_tag("")
	tag_history = [""]

var tag_history: Array = [""]
func set_tag(tag: String):
	tag_history.push_back(tag)
	label_tag.text = tag_history.back()
func set_tag_undo():
	tag_history.pop_back()
	label_tag.text = tag_history.back()

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
