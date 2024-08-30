extends Node

var states: Array = []
var state: int = 0
# Der Startknoten
var s: vertex_class

enum bfs_indices
{
	# [Momentan besuchte Kanten, Momentane Kante, Momentante Queue, Momentane Folge, Momentaner Current Knoten, Zeile im Pseudocode)
	currently_visited_edges,
	current_edge,
	current_queue,
	current_sequence,
	curernt_node,
	line_in_pseudo_code
}

func forward():
	if states.size() == 0:
		return
	if state == states.size() - 1:
		return
	
	state += 1
	update_visited_nodes()
	update_visited_edges()
	$own_gui/VBoxContainer/label_queue.text = " Queue Q = " + misc.int_array_to_string(states[state][2])
	$own_gui/VBoxContainer/label_sequence.text = " Folge F = " + misc.int_array_to_string(states[state][3])
	$own_gui/VBoxContainer/display.highlight_state(states[state][5])
	
	$own_gui/VBoxContainer/label_queue.visible = true
	$own_gui/VBoxContainer/label_sequence.visible = true

func backward():
	if state == 0:
		return
	state -= 1

	update_visited_nodes()
	update_visited_edges()
	$own_gui/VBoxContainer/label_queue.text = " Queue Q = " + misc.int_array_to_string(states[state][bfs_indices.current_queue])
	$own_gui/VBoxContainer/label_sequence.text = " Folge F = " + misc.int_array_to_string(states[state][bfs_indices.current_sequence])
	$own_gui/VBoxContainer/display.highlight_state(states[state][bfs_indices.line_in_pseudo_code])

	if(states[state][5] == []):
		$own_gui/VBoxContainer/label_queue.visible = false
		$own_gui/VBoxContainer/label_sequence.visible = false

func stop():
	s.label_id.set_text(str(s.id_))
	$own_gui.visible = false
	$own_gui/VBoxContainer/label_queue.visible = false
	$own_gui/VBoxContainer/label_sequence.visible = false

# Breitensuche, aber: Der Zustand aller relevanten Variablen der Breitensuche werden jeden Schritt gesichert
func algorithm(start_knoten: Node2D):
	# Init
	$own_gui.visible = true
	states.clear()
	start_knoten.label_id.set_text(str(start_knoten.id_) + " (s)")
	start_knoten.set_sprite(vertex_class.sprites.unselected)
	s = start_knoten
	
	$own_gui/VBoxContainer/display.set_text(tr("BFS_PSEUDOCODE")) 
	
	# Ein Zustand besteht aus:
	# [Momentan besuchte Kanten, Momentane Kante, Momentante Queue, Momentane Folge, Momentaner Current Knoten, Zeile im Pseudocode)
	states.push_back([[], null, [], [], null, []])
	
	# Ich weiß, diese Zeile ist cursed. Aber so funktioniert es eben in Godot ^^
	var queue: Array = []
	var erg: Array = []
	var besuchte_kanten = []
	states.push_back([besuchte_kanten.duplicate(), null, queue.duplicate(), erg.duplicate(), null, [1]])
	
	start_knoten.visited = true
	queue.push_back(start_knoten)
	erg.push_back(start_knoten)
	
	states.push_back([besuchte_kanten.duplicate(), null, queue.duplicate(), erg.duplicate(), null, [2]])
	
	while !queue.is_empty():
		var current: Node = queue.pop_front()
		states.push_back([besuchte_kanten.duplicate(), null, queue.duplicate(), erg.duplicate(), current, [4]])
		for kante in get_tree().get_nodes_in_group("edge_group" + str(current.id_)):
			besuchte_kanten.push_back(kante)
			states.push_back([besuchte_kanten.duplicate(), kante, queue.duplicate(), erg.duplicate(), current, [5]])	
			if !kante.target_vertex.visited:
				kante.target_vertex.visited = true
				queue.push_back(kante.target_vertex)
				erg.push_back(kante.target_vertex)
				states.push_back([besuchte_kanten.duplicate(), kante, queue.duplicate(), erg.duplicate(), current, [6, 7]])	
	states.push_back([besuchte_kanten.duplicate(), null, queue.duplicate(), erg.duplicate(), null, [8]])
	
	# Markiere alle Knoten wieder als unbesucht
	get_tree().call_group("vertex_group", "reset_visited")

	state = 0

	$own_gui/VBoxContainer/label_queue.text = " Queue: " + misc.int_array_to_string(states[state][bfs_indices.current_queue])
	$own_gui/VBoxContainer/label_sequence.text = " Folge: " + misc.int_array_to_string(states[state][bfs_indices.current_sequence])
	
	return states.size()

func update_visited_nodes():
	for knoten: vertex_class in get_tree().get_nodes_in_group("vertex_group"):
		knoten.set_sprite(vertex_class.sprites.unselected)
	for knoten: vertex_class in states[state][bfs_indices.current_sequence]:
		knoten.set_sprite(vertex_class.sprites.visited)
		
	if states[state][bfs_indices.curernt_node] != null:
		states[state][bfs_indices.curernt_node].set_sprite(vertex_class.sprites.current)

func update_visited_edges():
	for i in range(vertex_class.node_count):
		get_tree().call_group("edge_group" + str(i), "reset_color")
	for kante: edge_class in states[state][bfs_indices.currently_visited_edges]:
		kante.mark_visited()

