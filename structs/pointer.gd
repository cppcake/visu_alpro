class_name pointer_class extends Node2D

@export var label_start: Label
@export var label_start_text: String
@export var label_target: Label

var start
var target = null

# Needed to draw edge
var line: Line2D
var head: Polygon2D
var distance_head_node: float = 85

# Called when the node enters the scene tree for the first time.
func _ready():		
	line = get_node("./Line2D")
	head = get_node("./Polygon2D")
	label_start.text = label_start_text

var current_end_point: Vector2 = global_position + Vector2(0, 150)
func _physics_process(delta):
	var target_position: Vector2 = global_position + Vector2(0, 150)
	
	match type_string(typeof(target)):
		"Nil":
			label_target.text = "null"
		"Object":
			target_position = target.global_position
			label_target.text = ""
		"Vector2":
			target_position = target
			label_target.text = ""
	
	current_end_point = lerp(target_position, current_end_point, 21 * delta)
	draw(current_end_point)

func draw(target_position: Vector2 = current_end_point):
	label_start.position = Vector2(-50, -30)

	var distance: float = global_position.distance_to(target_position)
	var direction: Vector2 = (target_position - global_position).normalized()
	target_position = direction * (distance - distance_head_node)
	
	line.set_point_position(0, Vector2(0, 0))
	line.set_point_position(1, target_position)
	head.position = target_position
	head.rotation = Vector2(0, 0).angle_to_point(target_position)
	
	line.visible = true
	head.visible = true

func set_target(new_target):
	if target is list_vertex_class:
		target.reference_counter -= 1
	if new_target is list_vertex_class:
		new_target.reference_counter += 1
	target = new_target
	draw()
