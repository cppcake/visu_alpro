class_name HashVertex
extends anim_node

# Visuals of vertex 
@export var label_hash: Label
@export var label_key: Label
@export var p1: pointer_class

var hash_key_pair: HashKeyPair

func _ready():
	p1.current_end_point = global_position + Vector2(0, 150)
	p1.draw()
	p1.visible = true

func set_hash_key_pair(pair: HashKeyPair):
	hash_key_pair = pair
	label_hash.set_text(str(hash_key_pair.hash_value))
	label_key.set_text("\"" + str(hash_key_pair.key) + "\"")

func _on_mouse_entered():
	modulate = constants.hovered
func _on_mouse_exited():
	modulate = Color(1.0, 1.0, 1.0, 1.0)
