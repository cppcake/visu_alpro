extends Node2D

class_name edge_class

var start_knoten: Node2D
var ziel_knoten: Node2D
var line: Line2D
var head: Polygon2D
static var margin: float = 85

static var color_def: Color = Color.WHITE
static var color_visited: Color = constants.uni_hellblau_c

# Needed to properly draw an edge, if there exists a counteredge
var displacement: bool = false
static var displacement_factor: int = 15
# Number of points of per quarter circle
static var points_per_quarter_circle: int = 20
# Radius of circle
static var radius: float = 50

static var already_calculated = false
static var points_origin = []

# Called when the node enters the scene tree for the first time.
func _ready():
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
	draw()

func draw():
	if start_knoten != ziel_knoten:
		var start_punkt = start_knoten.position
		var ziel_punkt = ziel_knoten.position
		
		var distance: float = start_punkt.distance_to(ziel_punkt)
		var direction: Vector2 = (ziel_punkt - start_punkt).normalized()
		
		# Displace edge if there exists a counteredge
		if displacement == true:
			start_punkt += (direction.orthogonal().normalized() * displacement_factor)
			
		ziel_punkt = start_punkt + direction * (distance - margin)
		
		line.set_point_position(0, start_punkt)
		line.set_point_position(1, ziel_punkt)
		head.position = ziel_punkt
		head.rotation = start_punkt.angle_to_point(ziel_punkt)
		return

	if start_knoten == ziel_knoten:
		line.clear_points()
			
		var points = []
		# start_knoten.position.y
		for i in range(0, points_per_quarter_circle):
			points.push_back(Vector2(points_origin[i].x + start_knoten.position.x, points_origin[i].y + start_knoten.position.y - 65))
			
		for i in range(points.size()):
			line.add_point(points[i], i)
			
		var start_position = Vector2(start_knoten.position.x - radius, start_knoten.position.y - 69)
		head.position = start_position
		return

func mark_visited():
	line.default_color = color_visited
	head.color = color_visited

func reset_color():
	line.default_color = color_def
	head.color = color_def
