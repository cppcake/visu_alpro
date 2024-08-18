extends Node2D

class_name kanten_klasse

var start_knoten: Node2D
var ziel_knoten: Node2D
var linie: Line2D
var kopf: Polygon2D
static var margin: float = 85

static var color_def: Color = Color.WHITE
static var color_besucht: Color = constants.uni_hellblau_c

# Needed to properly draw an edge, if there exists a counteredge
var displacement: bool = false
static var displacement_factor: int = 15
# Number of points of per quarter circle
static var n: int = 20
# Radius of circle
static var r: float = 50

static var bereits_berechnet = false
static var points_origin = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if bereits_berechnet == false:
		for i in range(n + 1):
			var angle: float = (float)(2.0 * PI * i) / (n + (n/4.0));
			var y: float = cos(angle) * r
			var x: float = sin(angle) * r
			points_origin.push_back(Vector2(x, y))
		bereits_berechnet = true
			
	linie = get_node("./Line2D")
	kopf = get_node("./Polygon2D")

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
		
		linie.set_point_position(0, start_punkt)
		linie.set_point_position(1, ziel_punkt)
		kopf.position = ziel_punkt
		kopf.rotation = start_punkt.angle_to_point(ziel_punkt)
		return
		
	if start_knoten == ziel_knoten:
		linie.clear_points()
			
		var points = []
		# start_knoten.position.y
		for i in range(0, n):
			points.push_back(Vector2(points_origin[i].x + start_knoten.position.x, points_origin[i].y + start_knoten.position.y - 65))
			
		for i in range(points.size()):
			linie.add_point(points[i], i)
			
		var start_position = Vector2(start_knoten.position.x - r, start_knoten.position.y - 69)
		kopf.position = start_position
		return

func mark_visited():
	linie.default_color = color_besucht
	kopf.color = color_besucht

func reset_color():
	linie.default_color = color_def
	kopf.color = color_def
