extends Node

# Needed scenes
@onready var stack_frame_scene = preload("res://scenes/stack_frame.tscn")

# Everything needed to save the states
var states: Array = []
var current_state: int = 0
var current_stack: Array = []
var visited_vertices: Array = []
var visited_edges = []
var call_counter: int = 0
var last_pop

enum bfs_keys
{
	call_id, # The ID of the current Call
	F,
	Q, # current F'
	lines_to_paint, # The lines to paint on the display
	last_pop, # Array of [start vertex of call popped, ID of call popped]
	stack, # The current stack of calls
	visited_vertices,
	visited_edges,
	s, # starting vertex
	v # vertex w
}

func forward():
	current_state += 1
	update_visuals()

func backward():
	current_state -= 1
	update_visuals()

func stop():
	# Deactivate own gui
	$own_gui.visible = false

# Breitensuche, aber: Der Zustand aller relevanten Variablen der Breitensuche werden jeden Schritt gesichert
func algorithm(start_knoten: vertex_class):
	# Init pre Tiefensuche
	$own_gui.visible = true
	states.clear()
	current_stack.clear()
	visited_edges.clear()
	visited_vertices.clear()
	call_counter = 0

	var F = bfs(start_knoten)
	
	# Last state after return
	store_state(0, F, null, [], null, null, null)

	# Visualize the first step
	current_state = 0
	update_visuals()
	
	# Return the amount of states for the controller
	return states.size()

func bfs(s: vertex_class) -> Array:
	# Increment the number of counts and save the id of the call
	call_counter += 1
	var call_id = call_counter

	# Update the current stackframe
	current_stack.push_front([call_id, s.id_])
	
	# New state
	store_state(call_id, null, null, [], s, null, null)
	
	# Ich weiß, diese Zeile ist cursed. Aber so funktioniert es eben in Godot ^^
	var F: Array = []
	var Q: Array = []
	
	store_state(call_id, F, Q, [1], s, null, null)
	#states.push_back([besuchte_kanten.duplicate(), null, queue.duplicate(), erg.duplicate(), null, [1]])
	
	s.visited = true
	visited_vertices.push_back(s)
	F.push_back(s)
	Q.push_back(s)
	
	store_state(call_id, F, Q, [2], s, null, null)
	#states.push_back([besuchte_kanten.duplicate(), null, queue.duplicate(), erg.duplicate(), null, [2]])
	
	while !Q.is_empty():
		var v: Node = Q.pop_front()
		
		store_state(call_id, F, Q, [4], s, v, null)
		#states.push_back([besuchte_kanten.duplicate(), null, queue.duplicate(), erg.duplicate(), current, [4]])
		
		for edge in get_tree().get_nodes_in_group("edge_group" + str(v.id_)):
			visited_edges.push_back(edge)
			
			store_state(call_id, F, Q, [5], s, v, null)
			#states.push_back([besuchte_kanten.duplicate(), edge, queue.duplicate(), erg.duplicate(), current, [5]])	
			
			if !edge.target_vertex.visited:
				edge.target_vertex.visited = true
				visited_vertices.push_back(edge.target_vertex)
				F.push_back(edge.target_vertex)
				Q.push_back(edge.target_vertex)
				
				store_state(call_id, F, Q, [6, 7], s, v, null)
				#states.push_back([besuchte_kanten.duplicate(), edge, queue.duplicate(), erg.duplicate(), current, [6, 7]])	
	
	store_state(call_id, F, Q, [8], s, null, null)
	#states.push_back([besuchte_kanten.duplicate(), null, queue.duplicate(), erg.duplicate(), null, [8]])
	
	# We will return, update the last popped call and pop
	last_pop = [call_id, s]
	current_stack.pop_front()
	
	return F

func store_state(call_id: int, F, Q, lines_to_paint: Array, s: vertex_class, v:vertex_class, last_pop_p):
	# Create the dictionary for the state
	var dict: Dictionary = {}
	
	# Case F or F_2 not created yet (duplicate() only works on Arrays)
	if F != null:
		dict[bfs_keys.F] = F.duplicate()
	else:
		dict[bfs_keys.F] = F
	if Q != null:
		dict[bfs_keys.Q] = Q.duplicate()
	else:
		dict[bfs_keys.Q] = Q
		
	# Insert the values for each key in bfs_keys, see the enum above
	dict[bfs_keys.call_id] = call_id
	dict[bfs_keys.stack] = current_stack.duplicate()
	dict[bfs_keys.visited_edges] = visited_edges.duplicate()
	dict[bfs_keys.visited_vertices] = visited_vertices.duplicate()
	dict[bfs_keys.lines_to_paint] = lines_to_paint
	dict[bfs_keys.s] = s
	dict[bfs_keys.v] = v
	dict[bfs_keys.last_pop] = last_pop_p
	
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
		stack_frame_instance.get_child(0).text = tr("BREADTH-FIRST-SEARCH") + "(s = " + str(start_vertex_id) + ") (" + tr("CALL") + " " + str(stack_frame_id) +  ")"
		stackspeicher.add_child(stack_frame_instance)

@export var label_call: Label
@export var label_sequence: Label
@export var label_queue: Label
@export var label_return: Label
func update_code_labels(s: vertex_class, call_id: int, F, F_2, from):
	label_call.text = make_call_name(s, call_id)
	
	# Case return
	if call_id == 0:
		label_sequence.visible = false
		label_queue.visible = false
		label_return.visible = true
		label_return.text = "--> " + tr("TERMINATE") + misc.int_array_to_string(F)
		return
	
	label_return.visible = false
	
	if F == null:
		# Case F and F' not created yet
		label_sequence.visible = false
		label_queue.visible = false
	else:
		# Case F and F' created
		label_sequence.visible = true
		label_sequence.text = "F = " + misc.int_array_to_string(F)
		
		label_queue.visible = true
		label_queue.text = "Q = " +  misc.int_array_to_string(F_2)
	
	# Display whose return value F' is if needed
	if(from != null):
		label_queue.text = label_queue.text + " (" + tr("RETURN_VALUE_OF") + " " +  make_call_name(from[1], from[0]) + ")"

# Create a string like: DFS(s = x) (Call y) based on parameter
func make_call_name(s: vertex_class, call_id: int) -> String:
	var dfs_str: String = tr("BREADTH-FIRST-SEARCH")
	
	# Case Algorithm has returned
	if s == null:
		return dfs_str + "(s: " + tr("vertex") + ")"
	
	# Add start_vertex and caller id to call, always avaible when algorithm has not returned (eg. s != null)
	return dfs_str + "(s = " + str(s.id_) + ") (" + tr("CALL") + " " + str(call_id) + " )"

# Highlight selected lines in the pseudocode
@export var code_display: RichTextLabel
func update_lines_selected(lines_to_paint: Array):
	code_display.text = tr("BFS_PSEUDOCODE")
	for line_nr: int in lines_to_paint:
		code_display.paint_line(line_nr)

# Mark all visited vertices
func update_visited_vertices():
	for vertex: vertex_class in states[current_state].get(bfs_keys.visited_vertices):
		vertex.mark_visited()

# Update labels of vertices s and w
func update_s_v(s: vertex_class, v: vertex_class):
	if s != null:
		s.label_meta.text = "s "
	
	if v != null:
		v.label_meta.text = v.label_meta.text + "v"

# Mark visited edges
func update_visited_edges():
	for edge: edge_class in states[current_state].get(bfs_keys.visited_edges):
		edge.mark_visited()

# Apply the visuals of the current state
func update_visuals():
	var current_stack_frame: Array = states[current_state].get(bfs_keys.stack)
	var call_id: int = states[current_state].get(bfs_keys.call_id)
	var F = states[current_state].get(bfs_keys.F)
	var Q = states[current_state].get(bfs_keys.Q)
	var lines_to_paint = states[current_state].get(bfs_keys.lines_to_paint)
	var s = states[current_state].get(bfs_keys.s)
	var v = states[current_state].get(bfs_keys.v)
	var from = states[current_state].get(bfs_keys.last_pop)
	
	# Reset visuals
	# Reset sprites
	for knoten: vertex_class in get_tree().get_nodes_in_group("vertex_group"):
		knoten.set_sprite(vertex_class.sprites.unselected)
	# Reset labels
	get_tree().call_group("vertex_group", "reset_labels")
	# Reset edges
	for i in range(vertex_class.node_count):
		get_tree().call_group("edge_group" + str(i), "reset_color")
	
	# Redraw new visuals
	update_s_v(s, v)
	update_visited_vertices()
	update_visited_edges()
	draw_stack(current_stack_frame)
	update_code_labels(s, call_id, F, Q, from)
	update_lines_selected(lines_to_paint)


