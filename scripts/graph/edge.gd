class_name edge_class extends Node2D

var start_vertex: vertex_class
var target_vertex: vertex_class

# Needed to draw edge
var line: Line2D
var head: Polygon2D
static var distance_head_node: float = 85

# Needed to properly draw an edge, if there exists a counteredge
var displacement: bool = false
static var displacement_factor: int = 15

# Needed to draw circle edge
static var points_per_quarter_circle: int = 20
static var radius: float = 50
static var already_calculated = false
static var points_origin = []

# Needed to color edge during algorithm
static var color_def: Color = Color.WHITE
static var color_visited: Color = constants.uni_hellblau_c

# Called when the node enters the scene tree for the first time.
func _ready():
	# Calculate points of circle once and just once.
	# Use these points to draw circles by translating points.
	if already_calculated == false:
		for i in range(points_per_quarter_circle + 1):
			var angle: float = (float)(2.0 * PI * i) / (points_per_quarter_circle + (points_per_quarter_circle/4.0));
			var y: float = cos(angle) * radius
			var x: float = sin(angle) * radius
			points_origin.push_back(Vector2(x, y))
		already_calculated = true
			
	line = get_node("./Line2D")
	head = get_node("./Polygon2D")

func _process(_delta):
	# Draw edge every frame. Probably not the most efficient way, but it works reliably.
	draw()

func draw():
	# Case 01: Edge from once vertex to another
	if start_vertex != target_vertex:
		var start_position = start_vertex.position
		var target_position = target_vertex.position
		
		var distance: float = start_position.distance_to(target_position)
		var direction: Vector2 = (target_position - start_position).normalized()
		
		# Displace edge if there exists a counteredge
		if displacement == true:
			start_position += (direction.orthogonal().normalized() * displacement_factor)
			
		target_position = start_position + direction * (distance - distance_head_node)
		
		line.set_point_position(0, start_position)
		line.set_point_position(1, target_position)
		head.position = target_position
		head.rotation = start_position.angle_to_point(target_position)
		return

	#  Case 02: Edge from self to self
	if start_vertex == target_vertex:
		line.clear_points()
			
		var points = []
		for i in range(0, points_per_quarter_circle):
			points.push_back(Vector2(points_origin[i].x + start_vertex.position.x, points_origin[i].y + start_vertex.position.y - 65))
			
		for i in range(points.size()):
			line.add_point(points[i], i)
			
		var start_position = Vector2(start_vertex.position.x - radius, start_vertex.position.y - 69)
		head.position = start_position
		return

func mark_visited():
	line.default_color = color_visited
	head.color = color_visited

func reset_color():
	line.default_color = color_def
	head.color = color_def
