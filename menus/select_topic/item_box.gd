extends Panel

@export var texture_: Texture2D = load("res://menus/select_topic/images/placeholder.png")
@export var scene_name: String = ""
@export var label_text: String

@export var button: Button
@export var texture_rec: TextureRect
func _ready():
	button.text = label_text
	texture_rec.texture = texture_

func _on_button_pressed():
	var scene_man = scene_manager.new()
	add_child(scene_man)
	scene_man.change_scene(scene_name)
