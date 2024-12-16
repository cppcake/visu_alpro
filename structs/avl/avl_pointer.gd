extends pointer_class

func draw(target_position: Vector2 = current_end_point):
	if target == null:
		visible = false
		return
	
	label_start.position = Vector2(-50, -30)

	var distance: float = global_position.distance_to(target_position)
	var direction: Vector2 = (target_position - global_position).normalized()
	target_position = direction * (distance)

	line.set_point_position(0, Vector2(0, 0))
	line.set_point_position(1, target_position)
	line.visible = true
	visible = true
