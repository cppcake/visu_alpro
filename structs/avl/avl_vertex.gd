class_name avl_vertex extends tree_vertex_class

static var always_show = false

@export var panik: Sprite2D

@export var label_coef: Label
var coef: int = 2

func _process(delta):
	if always_show:
		if coef > 1 or coef < -1:
			label_coef.modulate = Color.RED
		else:
			label_coef.modulate = Color.WHITE
		label_coef.text = str(coef)

func update_reference_counter(addend: int):
	pass

func _on_mouse_entered():
	if coef > 1 or coef < -1:
		label_coef.modulate = Color.RED
		panik.visible = true
	label_coef.text = str(coef)
	super._on_mouse_entered()
func _on_mouse_exited():
	super._on_mouse_exited()
	panik.visible = false
	label_coef.modulate = Color.WHITE
	label_coef.text = ""

var coef_history: Array = []
func set_coef(new_coef: int):
	coef_history.push_back(new_coef)
	coef = new_coef
func set_coef_undo():
	coef_history.pop_back()
	coef = coef_history.back()
