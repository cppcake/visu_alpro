extends Node

# Modes
enum modes
{
	# Mode Vertices - Placing and removing nodes
	vertices,
	# Mode Edges - Placing and removing edges
	edges,
	# Mode Move - Moving nodes,
	move,
	# Mode BFS - Start BFS Demonstrator
	bfs,
	# Mode DFS - Start DFS Demonstrator
	dfs
}
var mode: modes = modes.vertices

# Graphenmanager
@export var graph_manager: Node

# Algorithm
var algorithm_running: bool = false
@export var bfs: Node

# Needed to display progress in algorithm
@export var state_counter: Label
var current_step: int = 1
var steps: int = 0

func _ready():	
	set_mode(mode)

func _process(_delta):
	# Get user input
	var left_click: bool = Input.is_action_just_pressed("M1")
	var left_click_released: bool = Input.is_action_just_released("M1")
	var right_click: bool = Input.is_action_just_pressed("M2")
	
	# Change state based on current mode and user input
	match mode:
		modes.vertices:
			if(left_click):
				graph_manager.add_vertex_at_mouse_pos()
			if(right_click):
				graph_manager.remove_vertex_at_mouse_pos()
				
		modes.edges:
			if(left_click):
				graph_manager.add_edge_between_selected()
					
			if(right_click):
				graph_manager.rm_edge_between_selected()
				
		modes.move:
			control_movement(left_click, left_click_released)
		
		modes.bfs:
			if algorithm_running:
				control_movement(left_click, left_click_released)
				
			if left_click and not algorithm_running:
				var collider = graph_manager.try_select_vertex()
				if collider != null:
					get_tree().call_group("buttons_active", "release_focus")
					current_step = 0
					steps = bfs.breitensuche(collider) - 1
					state_counter.text = str(current_step) + "/" + str(steps)
					navigation_mode()

func control_movement(left_click: bool, left_click_released: bool):
	if left_click:
		graph_manager.allow_vertex_at_mouse_pos_to_move()
	# Forbid node from moving
	if left_click_released:
		graph_manager.forbid_vertex_at_mouse_pos_to_move()

# ALGORITHM NAVIGATION
func forward():
	# Return, because we are already at the last step
	if(current_step >= steps):
		return
	
	match mode:
		modes.bfs:
			bfs.forward()
	
	current_step += 1
	state_counter.text = str(current_step) + "/" + str(steps)

func backward():
	# Return, because we are at the first step
	if(current_step <= 0):
		return
		
	match mode:
		modes.bfs:
			bfs.backward()
			
	current_step -= 1
	state_counter.text = str(current_step) + "/" + str(steps)

func stop():
	match mode:
		modes.bfs:
			bfs.stop()
			
	set_mode(modes.vertices)
	active_mode()
	state_counter.text = ""

# Unblock active buttons, block navigation buttons
func active_mode():
	algorithm_running = false
	for button: Button in get_tree().get_nodes_in_group("buttons_active"):
		button.disabled = false
		button.mouse_filter = button.MOUSE_FILTER_STOP
		
	for button: Button in get_tree().get_nodes_in_group("buttons_navigation"):
		button.disabled = true
		button.mouse_filter = button.MOUSE_FILTER_IGNORE

# Unblock navigation buttons, unblock active button
func navigation_mode():
	algorithm_running = true
	for button: Button in get_tree().get_nodes_in_group("buttons_active"):
		button.disabled = true
		button.mouse_filter = button.MOUSE_FILTER_IGNORE
		
	for button: Button in get_tree().get_nodes_in_group("buttons_navigation"):
		button.disabled = false
		button.mouse_filter = button.MOUSE_FILTER_STOP

@export var display: RichTextLabel
@export var button_knoten: Button
# Set current mode and info text accordingly
func set_mode(mode_: modes):
	mode = mode_
	match mode:
		modes.vertices:
			display.set_text(tr("CURRENT_MODE") + "[color=" + constants.uni_blau + "]VERTICES[/color]\n\t- Left click on grey area to add a vertex\n\t- Right click on a vertex to remove it")
			button_knoten.grab_focus()
		modes.edges:
			display.set_text(tr("CURRENT_MODE") + "[color=" + constants.uni_blau + "]EDGES[/color]\n\t- Left click on two vertices to add an edge between them\n\t- Right click on two vertices to remove edge between them")
		modes.move:
			display.set_text(tr("CURRENT_MODE") + "[color=" + constants.uni_blau + "]MOVE[/color]\n\t- Select and drag a vertex to move it")
		modes.bfs:
			display.set_text(tr("CURRENT_MODE") + "[color=" + constants.uni_blau + "]BFS[/color]\n\t- Select a vertex s to start a breadth-first search starting from it")
		modes.dfs:
			display.set_text("NOT YET IMPLEMENTED :(")
