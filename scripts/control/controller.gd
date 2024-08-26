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

@export var info_ui: ColorRect
@export var display: RichTextLabel
@export var button_knoten: Button
@export var button_kanten: Button
@export var button_move: Button
@export var button_bfs: Button
@export var button_dfs: Button

# Set current mode and info text accordingly. Also manually grab focus of modes button,
# in case mode was switched via code.
func set_mode(mode_: modes):
	mode = mode_
	match mode:
		modes.vertices:
			display.set_text(tr("CURRENT_MODE") + "[color=" + constants.uni_blau + "]" + tr("VERTICES") + "[/color]\n\t" + tr("VERTICES_INFO"))
			button_knoten.grab_focus()
		modes.edges:
			display.set_text(tr("CURRENT_MODE") + "[color=" + constants.uni_blau + "]" + tr("EDGES") + "[/color]\n\t" + tr("EDGES_INFO"))
			button_kanten.grab_focus()
		modes.move:
			display.set_text(tr("CURRENT_MODE") + "[color=" + constants.uni_blau + "]" + tr("MOVE") + "[/color]\n\t" + tr("MOVE_INFO"))
			button_move.grab_focus()
		modes.bfs:
			display.set_text(tr("CURRENT_MODE") + "[color=" + constants.uni_blau + "]" + tr("BFS") + "[/color]\n\t" + tr("BFS_INFO"))
			button_bfs.grab_focus()
		modes.dfs:
			display.set_text(tr("CURRENT_MODE") + "[color=" + constants.uni_blau + "]" + tr("DFS") + "[/color]\n\t" + tr("DFS_INFO"))
			button_dfs.grab_focus()

# Change the language, 0 - english; 1 - german and reapply the mode to update the info-text
func set_local(index: int):
	match index:
		0:
			TranslationServer.set_locale("en")
		1:
			TranslationServer.set_locale("de")
	set_mode(mode)

# There are two groups of buttons:
# - The active buttons group. It consists:
#	 - Buttons that manipulate the graph
#	 - Buttons to start algorithms
#	 - Some misc buttons (for example language switch)
# - The navigation buttons group
#	 - Buttons needed to navigate through the algorithm, eg. stop, -> and <-
#
# To make sure the language is not changed during an algorithm and to guarantee that
# the user does not navigate an algorithm that is not started (program would crash), at any
# given moment only one of the button-groups might be active. The methods below function as
# an interface for this purpose
#
# Unblock active buttons, block navigation buttons
func active_mode():
	# Reset graph appearance
	for knoten: vertex_class in get_tree().get_nodes_in_group("vertex_group"):
		knoten.set_sprite(vertex_class.sprites.unselected)
	for i in range(vertex_class.node_count):
		get_tree().call_group("edge_group" + str(i), "reset_color")
		
	# Make Info UI visible
	info_ui.visible = true
	
	algorithm_running = false
	
	# Unblock active buttons, block navigation buttons
	get_tree().call_group("buttons_navigation", "release_focus")
	for button: Button in get_tree().get_nodes_in_group("buttons_active"):
		button.disabled = false
		button.mouse_filter = button.MOUSE_FILTER_STOP
		
	for button: Button in get_tree().get_nodes_in_group("buttons_navigation"):
		button.disabled = true
		button.mouse_filter = button.MOUSE_FILTER_IGNORE
# Unblock navigation buttons, unblock active button
func navigation_mode():
	info_ui.visible = false
	get_tree().call_group("buttons_active", "release_focus")
	algorithm_running = true
	for button: Button in get_tree().get_nodes_in_group("buttons_active"):
		button.disabled = true
		button.mouse_filter = button.MOUSE_FILTER_IGNORE
		
	for button: Button in get_tree().get_nodes_in_group("buttons_navigation"):
		button.disabled = false
		button.mouse_filter = button.MOUSE_FILTER_STOP

# Allow / Forbid vertex from moving based on input		
func control_movement(left_click: bool, left_click_released: bool):
	if left_click:
		graph_manager.allow_vertex_at_mouse_pos_to_move()
	# Forbid vertex from moving
	if left_click_released:
		graph_manager.forbid_vertex_at_mouse_pos_to_move()

# To navigate an algorithm there is a -> and a <- button as well as the stop button,
# that are supposed to proceed a step forward/backward or stop the current algorithm. 
# To make sure these buttons work on every algorithm and to also make sure that the controller 
# is always in control, these buttons call their according function below.
# Based on the current algorithm, the controller will then call the equal function 
# of the currently active algorithm and do some clean ups/UI updates too.
# Thus every algorithm needs to support these functions!
#
# Proceed the algorithm one step forward and update state-counter
func forward():
	# Return, because we are already at the last step
	if(current_step >= steps):
		return
	
	match mode:
		modes.bfs:
			bfs.forward()
	
	# Update state-(counter)	
	current_step += 1
	state_counter.text = str(current_step) + "/" + str(steps)
# Proceed the algorithm one step backward and update state-counter
func backward():
	# Return, because we are at the first step
	if(current_step <= 0):
		return
		
	match mode:
		modes.bfs:
			bfs.backward()
		
	# Update state-counter
	current_step -= 1
	state_counter.text = str(current_step) + "/" + str(steps)
# Step the current algorithm
func stop():
	match mode:
		modes.bfs:
			bfs.stop()
			
	# Clean up
	set_mode(modes.vertices)
	active_mode()
	state_counter.text = ""

# Init
func _ready():
	# Set init language
	TranslationServer.set_locale("en")
	# Set init mode
	set_mode(mode)

# Control loop
func _process(_delta):
	# Get user input
	var left_click: bool = Input.is_action_just_pressed("M1")
	var left_click_released: bool = Input.is_action_just_released("M1")
	var right_click: bool = Input.is_action_just_pressed("M2")
	
	# Change state based on current mode and user input.
	match mode:
		modes.vertices:
			if(left_click):
				graph_manager.add_vertex_at_mouse_pos()
			if(right_click):
				graph_manager.remove_vertex_at_mouse_pos()
		
		# The graph manager keeps track of the selected vertices, we just need to ask
		# the graph manager to try connecting the selected vertices, if they exist
		modes.edges:
			if(left_click):
				graph_manager.add_edge_between_selected()
					
			if(right_click):
				graph_manager.rm_edge_between_selected()
				
		modes.move:
			control_movement(left_click, left_click_released)
		
		modes.bfs:
			# To make the vertices moveable during algorithm
			if algorithm_running:
				control_movement(left_click, left_click_released)
			
			# If the algorithm is not running, so no vertex has been selected yet.
			if left_click and not algorithm_running:
				# Try to select a vertex with the graph manager
				var collider = graph_manager.try_select_vertex()
				# If the selection was successful, start breitensuche on selected vertex
				# (There is nothing else to select but vertices anyways)
				if collider != null:
					current_step = 0
					steps = bfs.breitensuche(collider) - 1
					state_counter.text = str(current_step) + "/" + str(steps)
					navigation_mode()
		
		modes.dfs:
			# To make the vertices moveable during algorithm
			if algorithm_running:
				control_movement(left_click, left_click_released)
