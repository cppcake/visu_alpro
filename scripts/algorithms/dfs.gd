extends Node

var states: Array = []
var state: int = 0
# Der Startknoten
var s: vertex_class

enum dfs_indices
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
	state += 1

func backward():
	state -= 1

func stop():
	s.label_id.set_text(str(s.id_))
	$own_gui.visible = false

func algorithm(start_knoten: Node2D):
	# Init
	$own_gui.visible = true
	states.clear()

	state = 0
	return states.size()
