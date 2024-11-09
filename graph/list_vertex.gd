class_name list_vertex_class extends Area2D

# Static variables and functions
static var lerp_speed: int = 15;

# Visuals of vertex 
var label_data: Label
var p1: pointer_class

# Animation
var dest_pos

func _ready():
	label_data = get_child(2)
	
	p1 = get_child(3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Lerp vertex position to mouse position if vertex is allowed to move
	if dest_pos != null:
		global_position = lerp(global_position, dest_pos, lerp_speed * delta)

func move_to(dest_pos_: Vector2):
	if dest_pos != null:
		global_position = dest_pos
	dest_pos = dest_pos_

func _on_mouse_entered():
	modulate = constants.hovered

func _on_mouse_exited():
	modulate = Color(1.0, 1.0, 1.0, 1.0)
