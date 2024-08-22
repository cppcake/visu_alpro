extends Node

var states: Array = []
var state: int = 0
# Der Startknoten
var s: Node

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
	$meta_data_setion/VBoxContainer/label_queue.text = " Queue Q = " + int_array_to_string(states[state][2])
	$meta_data_setion/VBoxContainer/label_sequence.text = " Folge F = " + int_array_to_string(states[state][3])
	$meta_data_setion/VBoxContainer/display.highlight_state(states[state][5])
	
	$meta_data_setion/VBoxContainer/label_queue.visible = true
	$meta_data_setion/VBoxContainer/label_sequence.visible = true

func backward():
	if state == 0:
		return
	state -= 1

	update_visited_nodes()
	update_visited_edges()
	$meta_data_setion/VBoxContainer/label_queue.text = " Queue Q = " + int_array_to_string(states[state][bfs_indices.current_queue])
	$meta_data_setion/VBoxContainer/label_sequence.text = " Folge F = " + int_array_to_string(states[state][bfs_indices.current_sequence])
	$meta_data_setion/VBoxContainer/display.highlight_state(states[state][bfs_indices.line_in_pseudo_code])

	if(states[state][5] == []):
		$meta_data_setion/VBoxContainer/label_queue.visible = false
		$meta_data_setion/VBoxContainer/label_sequence.visible = false

func stop():
	s.label.set_text(str(s.id_))
	for knoten: knoten_klasse in get_tree().get_nodes_in_group("knoten_menge"):
		knoten.set_sprite(knoten_klasse.sprites.unselected)
	for i in range(knoten_klasse.node_count):
		get_tree().call_group("kanten_menge" + str(i), "reset_color")
	$meta_data_setion/VBoxContainer/label_queue.visible = false
	$meta_data_setion/VBoxContainer/label_sequence.visible = false

# Breitensuche, aber: Der Zustand aller relevanten Variablen der Breitensuche werden jeden Schritt gesichert
func breitensuche(start_knoten: Node2D):
	# Init
	states.clear()
	start_knoten.label.set_text(str(start_knoten.id_) + " (s)")
	start_knoten.set_sprite(knoten_klasse.sprites.unselected)
	s = start_knoten
	
	$meta_data_setion/VBoxContainer/display.set_text(" 1. Erstelle leere Folge F und eine leere Warteschlange (Queue) Q\n 2. Markiere s als erkundet und füge s in Q und F ein\n 3. [b]while[/b] Q ist nicht leer [b]do[/b]\n 4.  |  Sei v = Q.pop() \n 5.  |  [b]for[/b] alle Kanten (v, w) [b]do[/b] \n 6.  |   |  [b]if[/b] w ist noch unerkundet [b]then[/b] \n 7.  |   |   |  Markiere w als erkundet und füge w am Ende von Q und F ein \n 8. [b]return[/b] F") 
	
	# Ein Zustand besteht aus:
	# [Momentan besuchte Kanten, Momentane Kante, Momentante Queue, Momentane Folge, Momentaner Current Knoten, Zeile im Pseudocode)
	states.push_back([[], null, [], [], null, []])
	
	# Ich weiß, diese Zeile ist cursed. Aber so funktioniert es eben in der Godotengine ^^
	var queue: Array = []
	var erg: Array = []
	var besuchte_kanten = []
	states.push_back([besuchte_kanten.duplicate(), null, queue.duplicate(), erg.duplicate(), null, [1]])
	
	start_knoten.besucht = true
	queue.push_back(start_knoten)
	erg.push_back(start_knoten)
	
	states.push_back([besuchte_kanten.duplicate(), null, queue.duplicate(), erg.duplicate(), null, [2]])
	
	while !queue.is_empty():
		var current: Node = queue.pop_front()
		states.push_back([besuchte_kanten.duplicate(), null, queue.duplicate(), erg.duplicate(), current, [4]])
		for kante in get_tree().get_nodes_in_group("kanten_menge" + str(current.id_)):
			besuchte_kanten.push_back(kante)
			states.push_back([besuchte_kanten.duplicate(), kante, queue.duplicate(), erg.duplicate(), current, [5]])	
			if !kante.ziel_knoten.besucht:
				kante.ziel_knoten.besucht = true
				queue.push_back(kante.ziel_knoten)
				erg.push_back(kante.ziel_knoten)
				states.push_back([besuchte_kanten.duplicate(), kante, queue.duplicate(), erg.duplicate(), current, [6, 7]])	
	states.push_back([besuchte_kanten.duplicate(), null, queue.duplicate(), erg.duplicate(), null, [8]])
	
	# Markiere alle Knoten wieder als unbesucht
	get_tree().call_group("knoten_menge", "reset_besucht")

	state = 0

	$meta_data_setion/VBoxContainer/label_queue.text = " Queue: " + int_array_to_string(states[state][bfs_indices.current_queue])
	$meta_data_setion/VBoxContainer/label_sequence.text = " Folge: " + int_array_to_string(states[state][bfs_indices.current_sequence])
	
	return states.size()
	
func int_array_to_string(array: Array) -> String:
	if array.is_empty():
		return "[]"
		
	var string: String = "["
	for knoten: Node in array:
		string += str(knoten.id_)
		string += ", "
	#/string = string.erase(-2, 2)
	string += "]"
	return string

func update_visited_nodes():
	for knoten: knoten_klasse in get_tree().get_nodes_in_group("knoten_menge"):
		knoten.set_sprite(knoten_klasse.sprites.unselected)
	for knoten: knoten_klasse in states[state][bfs_indices.current_sequence]:
		knoten.set_sprite(knoten_klasse.sprites.besucht)
		
	if states[state][bfs_indices.curernt_node] != null:
		states[state][bfs_indices.curernt_node].set_sprite(knoten_klasse.sprites.current)

func update_visited_edges():
	for i in range(knoten_klasse.node_count):
		get_tree().call_group("kanten_menge" + str(i), "reset_color")
	for kante: kanten_klasse in states[state][bfs_indices.currently_visited_edges]:
		kante.mark_visited()

