extends Node

# Needed scenes
@onready var stack_frame_scene = preload("res://scenes/stack_frame.tscn")

# Der starting vertex
var s: vertex_class

# Everything needed to save the states
var states: Array = []
var state: int = 0
var current_stack: Array = []
var visited_vertices: Array = []
var visited_edges = []
var call_counter: int = 0
var last_pop: int

# We will save dictionaries in the states Array. These will have these keys:
enum dfs_keys
{
	call_id,
	F,
	F_2,
	lines_to_paint,
	last_pop,
	stack,
	visited_vertices,
	visited_edges,
	s,
	w
}

func algorithm(start_knoten: vertex_class):
	# Init
	$own_gui.visible = true
	s = start_knoten
	states.clear()
	current_stack.clear()
	visited_edges.clear()
	visited_vertices.clear()
	call_counter = 0
	last_pop = -1

	tiefensuche(start_knoten)

	state = 0
	update_visuals()
	return states.size()


func tiefensuche(start_vertex: vertex_class) -> Array:
	# Increment the number of counts and save the calls id
	call_counter += 1
	var call_id = call_counter
	
	# For good reasons trust me
	last_pop = -1
	
	# Update the current stackframe
	current_stack.push_front(call_id)
	
	# The beginning of a call is a state, create a state for it
	store_state(call_id, null, null, [], start_vertex, null, -1)
	
	# Create empty sequences F and F_2
	var F: Array = []
	var F_2: Array = []
	
	store_state(call_id, F, F_2, [1], start_vertex, null, -1)
	# Mark start_vertex as visited and push_back in F
	start_vertex.visited = true
	visited_vertices.push_back(start_vertex)
	F.push_back(start_vertex)
	
	store_state(call_id, F, F_2, [2], start_vertex, null, -1)
	var already_looped = false
	for outgoing_edge: edge_class in get_tree().get_nodes_in_group("edge_group" + str(start_vertex.id_)):
		visited_edges.push_back(outgoing_edge)
		if already_looped == false:
			store_state(call_id, F, F_2, [3], start_vertex, null, -1)
		else:
			store_state(call_id, F, F_2, [3], start_vertex, null, last_pop)
		
		var w: vertex_class = outgoing_edge.target_vertex
		if not w.visited:
			if already_looped == false:
				store_state(call_id, F, F_2, [4], start_vertex, w, -1)
			else:
				store_state(call_id, F, F_2, [4], start_vertex, w, last_pop)
			F_2 = tiefensuche(w)
			store_state(call_id, F, F_2, [4], start_vertex, w, last_pop)
			F.append_array(F_2)
			store_state(call_id, F, F_2, [5], start_vertex, w, last_pop)
			
			already_looped = true
	
	store_state(call_id, F, F_2, [6], start_vertex, null, last_pop)
	
	last_pop = call_id
	# We will return, so pop the stack
	current_stack.pop_front()
	
	#store_state(call_id - 1, F, F_2, [1], start_vertex, null)
	
	return F

func stop():
	get_tree().call_group("vertex_group", "reset_visited")
	s.label_id.set_text(str(s.id_))
	$own_gui.visible = false

func forward():
	state += 1
	
	update_visuals()
	
func backward():
	state -= 1

	update_visuals()

func store_state(call_id: int, F, F_2, lines_to_paint: Array, s_p: vertex_class, w_p:vertex_class, last_pop_p: int):
	var dict: Dictionary = {}
	dict[dfs_keys.call_id] = call_id
	if F != null:
		dict[dfs_keys.F] = F.duplicate()
		dict[dfs_keys.F_2] = F_2.duplicate()
	else:
		dict[dfs_keys.F] = F
		dict[dfs_keys.F_2] = F_2
	dict[dfs_keys.stack] = current_stack.duplicate()
	dict[dfs_keys.visited_edges] = visited_edges.duplicate()
	dict[dfs_keys.visited_vertices] = visited_vertices.duplicate()
	dict[dfs_keys.lines_to_paint] = lines_to_paint
	dict[dfs_keys.s] = s_p
	dict[dfs_keys.w] = w_p
	dict[dfs_keys.last_pop] = int(last_pop_p)
	states.push_back(dict)

@export var stackspeicher: VBoxContainer
func draw_stack(stack: Array):
	# Clear all stack frames before redrawing
	for child: Control in stackspeicher.get_children():
		child.queue_free()	

	# Draw the current stack
	for i in range(stack.size() - 1, -1, -1):
		var stack_frame_id: int = stack[i]
		print(stack_frame_id)
		var stack_frame_instance = stack_frame_scene.instantiate()
		# LOCAL FIX
		stack_frame_instance.get_child(0).text = "Tiefensuche (Aufruf " + str(stack_frame_id) +  ")"
		stackspeicher.add_child(stack_frame_instance)

@export var label_call: Label
@export var label_sequence: Label
@export var label_sequence_2: Label
func update_code_labels(call_id: int, F, F_2, from: int):
	var dfs_str: String = tr("DEPHT-FIRST-SEARCH")
	if call_id == 0:
		label_call.text = dfs_str
	else:
		var call_str: String = tr("CALL")
		label_call.text = dfs_str + " (" + call_str + " " + str(call_id) + " )"
		
	if F == null:
		label_sequence.visible = false
		label_sequence_2.visible = false
		return
	
	label_sequence.visible = true
	label_sequence.text = "F = " + misc.int_array_to_string(F)
	
	label_sequence_2.visible = true
	label_sequence_2.text = "F' = " +  misc.int_array_to_string(F_2)
	
	if(from != -1):
		label_sequence_2.text = label_sequence_2.text +  " (" + tr("RETURN_VALUE_OF") + " " + tr("CALL") + " " + str(from) + ")"

@export var code_display: RichTextLabel
func update_lines_selected(lines_to_paint: Array):
	code_display.text = tr("DFS_PSEUDOCODE")
	for line_nr: int in lines_to_paint:
		code_display.paint_line(line_nr)

func update_visited_vertices():
	for knoten: vertex_class in get_tree().get_nodes_in_group("vertex_group"):
		knoten.set_sprite(vertex_class.sprites.unselected)
	for vertex: vertex_class in states[state].get(dfs_keys.visited_vertices):
		vertex.set_sprite(vertex_class.sprites.visited)
		
func update_s_w(s_p: vertex_class, w_p: vertex_class):
	get_tree().call_group("vertex_group", "reset_labels")
	s_p.label_id.text = s_p.label_id.text + " (s)"
	
	if w_p != null:
		w_p.label_id.text = w_p.label_id.text + " (w)"
	
func update_visited_edges():
	for i in range(vertex_class.node_count):
		get_tree().call_group("edge_group" + str(i), "reset_color")
	for edge: edge_class in states[state].get(dfs_keys.visited_edges):
		edge.mark_visited()

func update_visuals():
	var current_stack_frame: Array = states[state].get(dfs_keys.stack)
	var call_id: int = states[state].get(dfs_keys.call_id)
	var F = states[state].get(dfs_keys.F)
	var F_2 = states[state].get(dfs_keys.F_2)
	var lines_to_paint = states[state].get(dfs_keys.lines_to_paint)
	var s_p = states[state].get(dfs_keys.s)
	var w_p = states[state].get(dfs_keys.w)
	var from = states[state].get(dfs_keys.last_pop)
	
	update_s_w(s_p, w_p)
	update_visited_vertices()
	update_visited_edges()
	draw_stack(current_stack_frame)
	update_code_labels(call_id, F, F_2, from)
	update_lines_selected(lines_to_paint)
