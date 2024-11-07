extends Node

@export var graph_snaper: GraphSnaper
@export var camera: CameraManager

# Called when the node enters the scene tree for the first time.
var graphs: Array
func _ready():
	graph_snaper.add_vertex("xD", Vector2(100, 200))
	graphs.append(graph_snaper.make_snapshot())
	
	graph_snaper.add_vertex("xxD", Vector2(-100, 150))
	graphs.append(graph_snaper.make_snapshot())
	
	graph_snaper.add_vertex("xxxD", Vector2(250, 200))
	graphs.append(graph_snaper.make_snapshot())
	
	graph_snaper.add_vertex("xxxxD", Vector2(-200, 200))
	graphs.append(graph_snaper.make_snapshot())
	
var i = 0
func _process(delta):
	var left_click = Input.is_action_just_pressed("M1")
	if left_click:
		graph_snaper.play_snapshot(graphs[i])
