class_name GraphSnaper2 extends Node

var graph_manager: GraphManager

func _ready():
	graph_manager = get_child(0)

func make_snapshot() -> GraphManager:
	var graph_snapshot = graph_manager.duplicate(7)
	for child in graph_snapshot.get_children():
		child.visible = false
	return graph_snapshot

func play_snapshot(graph: GraphManager) -> void:
	# Add the vertices
	graph_manager.free()
	graph_manager = graph
	for child in graph_manager.get_children():
		child.visible = true
# Add vertex and return its adress
func add_vertex(name: String, position: Vector2):
	var new_vertex = graph_manager.add_vertex(position)
	if name == "Head" or name == "Tail" or name == "null":
		new_vertex.sprite.visible = false
	new_vertex.label_id.text = name
	return new_vertex
	
func rm_vertex(vertex: vertex_class):
	graph_manager.rm_vertex(vertex)
	
func add_edge(vertex_1: vertex_class, vertex_2: vertex_class):
	graph_manager.add_edge(vertex_1, vertex_2)

func remove_edge(vertex_1: vertex_class, vertex_2: vertex_class):
	graph_manager.rd_edge(vertex_1, vertex_2)
