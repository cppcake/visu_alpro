class_name GraphSnaper extends Node

var graph_manager: GraphManager

var memory: Array

var types: Array
var positions: Array
var edges: Array

func _ready():
	graph_manager = get_child(0)

func make_snapshot() -> Array:
	return [types.duplicate(), positions.duplicate(), edges.duplicate()]

func play_snapshot(snapshot: Array) -> void:
	types = snapshot[0]
	positions = snapshot[1]
	edges = snapshot[2]
	
	# Add the vertices
	for i in range(types.size()):
		if types[i] == null:
			memory[i].position(Vector2(10000, 10000))
			memory[i].visible = false
			continue
		memory[i] = positions[i]
	
	graph_manager.clear_edges()
	
	for edge in edges:
		if edge == null:
			continue
		add_edge(edge[0], edge[1])

# Add vertex and return its adress
func add_vertex(type: String, position: Vector2):
	types.append(type)
	positions.append(position)
	var new_vertex = graph_manager.add_vertex(position)
	if type == "Head" or type == "Tail" or type == "null":
		new_vertex.sprite.visible = false
	new_vertex.label_id.text = type
	memory.append(new_vertex)
	return memory.size()

func rm_vertex(addr: int):
	types[addr] = null
	positions[addr] = null
	for i in range(edges.size()):
		if edges[i][0] == addr or edges[i][1] == addr:
			edges[i] = null
	
func add_edge(addr_1: int, addr_2: int):
	graph_manager.add_edge(memory[addr_1], memory[addr_2])
	edges.append([addr_1, addr_2])

func remove_edge(addr_1: int, addr_2: int):
	for i in range(edges.size()):
		if edges[i][0] == addr_1 and edges[i][1] == addr_2:
			edges[i] = null
