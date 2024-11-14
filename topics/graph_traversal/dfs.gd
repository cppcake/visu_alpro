extends Node

# Needed scenes
@onready var stack_frame_scene = preload("res://topics/ui/scenes/stack_frame.tscn")

# Everything needed to save the states
var states: Array = []
var current_step: int = 0
var current_stack: Array = []
var visited_vertices: Array = []
var visited_edges = []
var call_counter: int = 0
var last_pop

# We will save dictionaries in the states Array. These will have these keys:
enum dfs_keys
{
	call_id, # The ID of the current Call
	F,
	F_2, # current F'
	lines_to_paint, # The lines to paint on the display
	last_pop, # Array of [start vertex of call popped, ID of call popped]
	stack, # The current stack of calls
	visited_vertices,
	visited_edges,
	s, # starting vertex
	w, # vertex w
	current_edge
}

@export var side_panel: SidePanel


var label_sequence: Label
var label_sequence_2: Label
func init(start_knoten: vertex_class):
	# Init pre Tiefensuche
	side_panel.select_containers(1, 1, 1, 0)
	label_sequence = side_panel.create_variable()
	label_sequence_2 = side_panel.create_variable()
	
	states.clear()
	current_stack.clear()
	visited_edges.clear()
	visited_vertices.clear()
	call_counter = 0

	var F = dfs(start_knoten)
	
	# Last state after return
	store_state(0, F, null, [], null, null, null, null)

	# Return the amount of states for the controller
	return states.size()

# DFS but the state of the algorithm is saved in specific steps
func dfs(start_vertex: vertex_class) -> Array:
	side_panel.override_code(tr("DFS_PSEUDOCODE"))
	
	# Increment the number of counts and save the id of the call
	call_counter += 1
	var call_id = call_counter
	
	# For good reasons trust me
	last_pop = null
	
	# Update the current stackframe
	current_stack.push_front([call_id, start_vertex.id_])
	
	# New state
	store_state(call_id, null, null, [], start_vertex, null, null, null)
	
	# Create empty sequences F and F_2
	var F: Array = []
	var F_2: Array = []
	
	# New state
	store_state(call_id, F, F_2, [1], start_vertex, null, null, null)
	
	# Mark start_vertex as visited and push_back in F
	start_vertex.visited = true
	visited_vertices.push_back(start_vertex)
	F.push_back(start_vertex)
	
	# New state
	store_state(call_id, F, F_2, [2], start_vertex, null, null, null)
	
	# This variable is needed for a sneaky edge case in the visualisation. Its hard to exlain.
	var already_looped = false
	
	# Loop part
	for outgoing_edge: edge_class in get_tree().get_nodes_in_group("edge_group" + str(start_vertex.id_)):
		visited_edges.push_back(outgoing_edge)
		var w: vertex_class = outgoing_edge.target_vertex
		if already_looped == false:
			# New state
			store_state(call_id, F, F_2, [3], start_vertex, w, null, outgoing_edge)
		else:
			# New state
			store_state(call_id, F, F_2, [3], start_vertex, w, last_pop, outgoing_edge)
		
		if not w.visited:
			if already_looped == false:
				# New state
				store_state(call_id, F, F_2, [4], start_vertex, w, null, outgoing_edge)
			else:
				# New state
				store_state(call_id, F, F_2, [4], start_vertex, w, last_pop, outgoing_edge)
			
			# The recrusiv part
			F_2 = dfs(w)
			
			# New state
			store_state(call_id, F, F_2, [4], start_vertex, w, last_pop, outgoing_edge)
			
			# Append the return value of last call to sequence
			F.append_array(F_2)
			
			# New state
			store_state(call_id, F, F_2, [5], start_vertex, w, last_pop, outgoing_edge)
			
			already_looped = true
	
	# New state
	store_state(call_id, F, F_2, [6], start_vertex, null, last_pop, null)
	
	# We will return, update the last popped call and pop
	last_pop = [call_id, start_vertex]
	current_stack.pop_front()
	
	return F

# Visualize a certain step
func visualize_step(step: int) -> void:
	current_step = step
	update_visuals()

# Clean up before controller stops algorithm
func stop():
	# Deactivate own gui
	pass

# Create and push a new state on the array of states
# A state stores the state of the algorithm at the time of creating the state
# See the enum above to fin out what a state contains
func store_state(	call_id: int,
					F,
					F_2,
					lines_to_paint: Array,
					s: vertex_class,
					w:vertex_class,
					last_pop_p,
					current_edge):
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
	dict[dfs_keys.s] = s
	dict[dfs_keys.w] = w
	dict[dfs_keys.last_pop] = last_pop_p
	dict[dfs_keys.current_edge] = current_edge
	
	# Push the new state
	states.push_back(dict)

func draw_stack(stack: Array):
	# Clear all stack frames before redrawing
	side_panel.reset(0, 0, 1, 0)

	# Iterate through stack in reverse
	for i in range(stack.size() - 1, -1, -1):
		var stack_frame_id: int = stack[i][0]
		var start_vertex_id: int = stack[i][1]
		var stack_frame_label = side_panel.push_call()
		stack_frame_label.text = tr("DEPHT-FIRST-SEARCH") + "(s = " + str(start_vertex_id) + ") (" + tr("CALL") + " " + str(stack_frame_id) +  ")"

func update_code_labels(s: vertex_class, call_id: int, F, F_2, from):
	side_panel.override_code_call(make_call_name(s, call_id))
	
	# Case return
	if call_id == 0:
		label_sequence.visible = false
		label_sequence_2.visible = false
		side_panel.override_code_return(tr("TERMINATE") + helper_functions.vertex_array_to_string(F))
		return
	
	side_panel.override_code_return("")
	
	if F == null:
		# Case F and F' not created yet
		label_sequence.visible = false
		label_sequence_2.visible = false
	else:
		# Case F and F' created
		label_sequence.visible = true
		label_sequence.text = "F = " + helper_functions.vertex_array_to_string(F)
		
		label_sequence_2.visible = true
		label_sequence_2.text = "Q = " +  helper_functions.vertex_array_to_string(F_2)
	
	# Display whose return value F' is if needed
	if(from != null):
		label_sequence_2.text = label_sequence_2.text + " (" + tr("RETURN_VALUE_OF") + " " +  make_call_name(from[1], from[0]) + ")"

# Create a string like: DFS(s = x) (Call y) based on parameter
func make_call_name(s: vertex_class, call_id: int) -> String:
	var dfs_str: String = tr("DEPHT-FIRST-SEARCH")
	
	# Case Algorithm has returned
	if s == null:
		return dfs_str + "(s: " + tr("vertex") + ")"
	
	# Add start_vertex and caller id to call, always avaible when algorithm has not returned (eg. s != null)
	return dfs_str + "(s = " + str(s.id_) + ") (" + tr("CALL") + " " + str(call_id) + ")"

# Mark all visited vertices
func update_visited_vertices():
	for vertex: vertex_class in states[current_step].get(dfs_keys.visited_vertices):
		vertex.mark_visited()

# Update labels of vertices s and w
func update_s_w(s: vertex_class, w: vertex_class):
	if s != null:
		s.label_meta.text = "s"
	
	if w != null:
		w.label_meta.text = "w"
		
	if w == s and w != null:
		s.label_meta.text = "s w"

# Mark visited edges
func update_visited_edges():
	for edge: edge_class in states[current_step].get(dfs_keys.visited_edges):
		edge.mark_visited()
	
	var current_edge = states[current_step].get(dfs_keys.current_edge)
	if current_edge != null:
		current_edge.mark_freshly_visited()

# Apply the visuals of the current state
func update_visuals():
	var current_stack_frame: Array = states[current_step].get(dfs_keys.stack)
	var call_id: int = states[current_step].get(dfs_keys.call_id)
	var F = states[current_step].get(dfs_keys.F)
	var F_2 = states[current_step].get(dfs_keys.F_2)
	var lines_to_paint = states[current_step].get(dfs_keys.lines_to_paint)
	var s = states[current_step].get(dfs_keys.s)
	var w = states[current_step].get(dfs_keys.w)
	var from = states[current_step].get(dfs_keys.last_pop)
	
	# Reset visuals
	# Reset sprites
	for vertex: vertex_class in get_tree().get_nodes_in_group("vertex_group"):
		vertex.set_sprite(vertex_class.sprites.unselected)
	# Reset labels
	get_tree().call_group("vertex_group", "reset_labels")
	# Reset edges
	for i in range(vertex_class.node_count):
		get_tree().call_group("edge_group" + str(i), "reset_color")
	
	# Redraw new visuals
	update_s_w(s, w)
	update_visited_vertices()
	update_visited_edges()
	draw_stack(current_stack_frame)
	update_code_labels(s, call_id, F, F_2, from)
	side_panel.highlight_code(lines_to_paint)
