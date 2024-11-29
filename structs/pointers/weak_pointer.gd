class_name weak_pointer_class extends pointer_class

func _ready():
	distance_factor = 0.65
	super._ready()
	set_color(colors.WEAK)
	
func set_target(new_target):
	last_target = target
	target = new_target
	draw()
