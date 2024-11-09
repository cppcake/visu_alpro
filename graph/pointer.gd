class_name pointer_class extends Node2D

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

func _process(_delta):
	draw()

func draw():
	head.visible = true
	
	var target_position: Vector2
	
	match type_string(typeof(target)):
		"Nil":
			target_position = position + Vector2(0, 150)
			print("pointing at null")
		"Object":
			target_position = to_local(target.global_position)
			print("pointing at object")
		"Vector2":
			target_position = to_local(target)
			print("pointing at position")
	
	var distance: float = position.distance_to(target_position)
	var direction: Vector2 = (target_position - position).normalized()
	target_position = position + direction * (distance - distance_head_node)
	
	line.set_point_position(0, position)
	line.set_point_position(1, target_position)
	head.position = target_position
	head.rotation = position.angle_to_point(target_position)
