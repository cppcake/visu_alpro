extends Node

# Needed scenes
@onready var stack_frame_scene = preload("res://scenes/stack_frame.tscn")

# Der starting vertex
var s: vertex_class

# Everything needed to save the states
var states: Array = []
var state: int = 0
var current_stack: Array = []
var visited_edges = []
var call_counter: int = 0

# We will save dictionaries in the states Array. These will have these keys:
enum dfs_keys
{
	call_id,
	stack,
	last_pop,
	visited_edges,
	F,
	F_2,
	line_nr
}

func algorithm(start_knoten: vertex_class):
	# Init
	$own_gui.visible = true
	s = start_knoten
	states.clear()
	current_stack.clear()
	visited_edges.clear()
	call_counter = 0

	tiefensuche(start_knoten)

	state = 0
	draw_stack(states[state].get(dfs_keys.stack))
	return states.size()


func tiefensuche(start_vertex: vertex_class) -> Array:
	# Increment the number of counts and save the calls id
	call_counter += 1
	var call_id = call_counter
	
	# Update the current stackframe
	current_stack.push_front(call_id)
	
	# The beginning of a call is a state, create a dict for it
	var dict_beginning: Dictionary
	dict_beginning[dfs_keys.call_id] = call_id
	dict_beginning[dfs_keys.stack] = current_stack.duplicate()
	dict_beginning[dfs_keys.visited_edges] = visited_edges.duplicate()
	#dict_beginning[dfs_keys.last_pop] = null
	#dict_beginning[dfs_keys.F] = null
	#dict_beginning[dfs_keys.F_2] = null
	
	# Push the new state
	states.push_back(dict_beginning)
	
	# Create empty sequences F and F_2
	var F: Array
	var F_2: Array
	
	# Mark start_vertex as visited and push_back in F
	start_vertex.visited = true
	F.push_back(start_vertex)
	
	for outgoing_edge: edge_class in get_tree().get_nodes_in_group("edge_group" + str(start_vertex.id_)):
		if not outgoing_edge.target_vertex.visited:
			visited_edges.push_back(outgoing_edge)
			
			var dict_loop: Dictionary
			dict_loop[dfs_keys.call_id] = call_id
			dict_loop[dfs_keys.stack] = current_stack.duplicate()
			dict_loop[dfs_keys.visited_edges] = visited_edges.duplicate()
			states.push_back(dict_loop)
			
			F_2 = tiefensuche(outgoing_edge.target_vertex)
			F.append_array(F_2)
			
			var dict_loop_2: Dictionary
			dict_loop_2[dfs_keys.call_id] = call_id
			dict_loop_2[dfs_keys.stack] = current_stack.duplicate()
			dict_loop_2[dfs_keys.visited_edges] = visited_edges.duplicate()
			#dict_loop[dfs_keys.last_pop] = null
			#dict_loop[dfs_keys.F] = F
			#dict_loop[dfs_keys.F_2] = F_2
			states.push_back(dict_loop_2)
	
	# We will return, so pop the stack
	current_stack.pop_front()
	
	# The beginning of a call is a state, create a dict for it
	var dict_end: Dictionary
	dict_end[dfs_keys.call_id] = call_id
	dict_end[dfs_keys.stack] = current_stack.duplicate()
	dict_end[dfs_keys.visited_edges] = visited_edges.duplicate()
	states.push_back(dict_end)
	
	return F

func stop():
	get_tree().call_group("vertex_group", "reset_visited")
	s.label_id.set_text(str(s.id_))
	$own_gui.visible = false

@export var stackspeicher: VBoxContainer
#@export 

func forward():
	state += 1
	
	update_visited_edges()
	var current_stack_frame: Array = states[state].get(dfs_keys.stack)
	draw_stack(current_stack_frame)
	

func backward():
	state -= 1

	update_visited_edges()
	var current_stack_frame: Array = states[state].get(dfs_keys.stack)
	draw_stack(current_stack_frame)

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

func update_visited_edges():
	for i in range(vertex_class.node_count):
		get_tree().call_group("edge_group" + str(i), "reset_color")
	for edge: edge_class in states[state].get(dfs_keys.visited_edges):
		edge.mark_visited()
