extends Node

# Needed scenes
@onready var stack_frame_scene = preload("res://scenes/stack_frame.tscn")

# Der starting vertex
var s: vertex_class

# Everything needed to save the states
var states: Array = []
var current_state: int = 0
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

	var F = dfs(start_knoten)
	
	# Last state after return
	store_state(0, F, null, [], null, null, -1)

	current_state = 0
	update_visuals()
	return states.size()

#
func dfs(start_vertex: vertex_class) -> Array:
	# Increment the number of counts and save the calls id
	call_counter += 1
	var call_id = call_counter
	
	# For good reasons trust me
	last_pop = -1
	
	# Update the current stackframe
	current_stack.push_front([call_id, start_vertex.id_])
	
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
			F_2 = dfs(w)
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

# Clean up before controller stops algorithm
func stop():
	# Deactivate own gui
	$own_gui.visible = false

# Increment the current state and update the visuals
func forward():
	current_state += 1
	
	update_visuals()

# Decrement the current state and update the visuals
func backward():
	current_state -= 1

	update_visuals()

# Create and push a new state on the array of states
# A state stores the state of the algorithm at the time of creating the state
# See the enum above to fin out what a state contains
func store_state(call_id: int, F, F_2, lines_to_paint: Array, s_p: vertex_class, w_p:vertex_class, last_pop_p: int):
	# Create the dictionary for the state
	var dict: Dictionary = {}
	
	# Case F or F_2 not created yet (duplicate() only works on Arrays)
	if F != null:
		dict[dfs_keys.F] = F.duplicate()
	else:
		dict[dfs_keys.F] = F
	if F_2 != null:
		dict[dfs_keys.F_2] = F_2.duplicate()
	else:
		dict[dfs_keys.F_2] = F_2
		
	# Insert the values for each key in dfs_keys, see the enum above
	dict[dfs_keys.call_id] = call_id
	dict[dfs_keys.stack] = current_stack.duplicate()
	dict[dfs_keys.visited_edges] = visited_edges.duplicate()
	dict[dfs_keys.visited_vertices] = visited_vertices.duplicate()
	dict[dfs_keys.lines_to_paint] = lines_to_paint
	dict[dfs_keys.s] = s_p
	dict[dfs_keys.w] = w_p
	dict[dfs_keys.last_pop] = int(last_pop_p)
	
	# Push the new state
	states.push_back(dict)

@export var stackspeicher: VBoxContainer
func draw_stack(stack: Array):
	# Clear all stack frames before redrawing
	for child: Control in stackspeicher.get_children():
		child.queue_free()	

	# Iterate through stack in reverse
	for i in range(stack.size() - 1, -1, -1):
		var stack_frame_id: int = stack[i][0]
		var start_vertex_id: int = stack[i][1]
		var stack_frame_instance = stack_frame_scene.instantiate()
		stack_frame_instance.get_child(0).text = tr("DEPHT-FIRST-SEARCH") + "(s = " + str(start_vertex_id) + ") (" + tr("CALL") + " " + str(stack_frame_id) +  ")"
		stackspeicher.add_child(stack_frame_instance)

@export var label_call: Label
@export var label_sequence: Label
@export var label_sequence_2: Label
@export var label_return: Label
func update_code_labels(s_p: vertex_class, call_id: int, F, F_2, from: int):
	var dfs_str: String = tr("DEPHT-FIRST-SEARCH")
	
	# Case return
	if call_id == 0:
		label_call.text = dfs_str + "(s: " + tr("vertex") + ")"
		label_sequence.visible = false
		label_sequence_2.visible = false
		label_return.visible = true
		label_return.text = "--> " + tr("TERMINATE") + misc.int_array_to_string(F)
		return
	
	label_return.visible = false
	
	# Add start_vertex and caller id to call, always avaible when algorithm has not returned
	
	var call_str: String = tr("CALL")
	var s_id = s_p.id_
	label_call.text = dfs_str + "(s = " + str(s_id) + ") (" + call_str + " " + str(call_id) + " )"
	
	if F == null:
		# Case F and F' not created yet
		label_sequence.visible = false
		label_sequence_2.visible = false
	else:
		# Case F and F' created
		label_sequence.visible = true
		label_sequence.text = "F = " + misc.int_array_to_string(F)
		
		label_sequence_2.visible = true
		label_sequence_2.text = "F' = " +  misc.int_array_to_string(F_2)
	
	# Display whose return value F' is if needed
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
	for vertex: vertex_class in states[current_state].get(dfs_keys.visited_vertices):
		vertex.set_sprite(vertex_class.sprites.visited)

func update_s_w(s_p: vertex_class, w_p: vertex_class):
	get_tree().call_group("vertex_group", "reset_labels")
	
	if s_p != null:
		s_p.label_id.text = s_p.label_id.text + " (s)"
	
	if w_p != null:
		w_p.label_id.text = w_p.label_id.text + " (w)"
	
func update_visited_edges():
	for i in range(vertex_class.node_count):
		get_tree().call_group("edge_group" + str(i), "reset_color")
	for edge: edge_class in states[current_state].get(dfs_keys.visited_edges):
		edge.mark_visited()

func update_visuals():
	var current_stack_frame: Array = states[current_state].get(dfs_keys.stack)
	var call_id: int = states[current_state].get(dfs_keys.call_id)
	var F = states[current_state].get(dfs_keys.F)
	var F_2 = states[current_state].get(dfs_keys.F_2)
	var lines_to_paint = states[current_state].get(dfs_keys.lines_to_paint)
	var s_p = states[current_state].get(dfs_keys.s)
	var w_p = states[current_state].get(dfs_keys.w)
	var from = states[current_state].get(dfs_keys.last_pop)
	
	update_s_w(s_p, w_p)
	update_visited_vertices()
	update_visited_edges()
	draw_stack(current_stack_frame)
	update_code_labels(s_p, call_id, F, F_2, from)
	update_lines_selected(lines_to_paint)
