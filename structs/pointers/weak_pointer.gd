class_name weak_pointer_class extends pointer_class

func _process(delta):
	if target == null:
		distance_factor = 10
	else:
		distance_factor = 33

func _ready():
	distance_factor = 33
	super._ready()
	set_color(colors.WEAK)
	
func set_target(new_target):		
	last_target = target
	target = new_target
	draw()
