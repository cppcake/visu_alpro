class_name weak_pointer_class extends pointer_class


func _ready():
	distance_factor = 0.65
	super._ready()
	line.default_color = constants.weak_pointer_color_c
	head.color = constants.weak_pointer_color_c
	
func set_target(new_target):
	target = new_target
	draw()
