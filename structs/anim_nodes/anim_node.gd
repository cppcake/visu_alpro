class_name anim_node extends Node2D

@export var lerp_speed: float = 15
var dest_pos = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if dest_pos != null:
		global_position = lerp(global_position, dest_pos, lerp_speed * delta)

var dest_pos_history: Array = []
func move_to(dest_pos_: Vector2, save: bool = true):
	if save and dest_pos != null:
		dest_pos_history.push_back(dest_pos)
	
	if dest_pos != null:
		global_position = dest_pos
	dest_pos = dest_pos_
func move_to_undo():
	if dest_pos_history.size() == 0:
		return
	move_to(dest_pos_history.pop_back(), false)

func move_to_rel(offset: Vector2):
	print(offset)
	move_to(position + offset)
