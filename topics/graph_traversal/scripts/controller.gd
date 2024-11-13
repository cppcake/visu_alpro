extends Node

# User input
var left_click: bool
var left_click_released: bool
var right_click: bool

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
	dfs,
	# Hehe
	easteregg
}
var mode: modes = modes.vertices

# Graphenmanager
@export var graph_manager: Node

# Algorithm stuff
var algorithm_running: bool = false
var current_algorithm: Node
@export var algorithms: Node

# Needed to display progress of algorithm
@export var state_counter: Label
var current_step: int = 1
var algorithm_step_count: int = 0

# Needed to manipulate upper_ui efficiently
@export var button_knoten: Button
@export var button_kanten: Button
@export var button_move: Button
@export var button_bfs: Button
@export var button_dfs: Button

# Set current mode and info text accordingly. Also manually grab focus of modes button,
# in case mode was switched via code.
@export var side_panel: SidePanel
func set_mode(mode_: modes):
	side_panel.select_containers(0, 0, 0, 1)
	mode = mode_
	match mode:
		modes.vertices:
			side_panel.override_exp(tr("CURRENT_MODE") + "[color=" + constants.color_1 + "]" + tr("VERTICES") + "[/color]\n\t" + tr("VERTICES_INFO"))
			button_knoten.grab_focus()
		modes.edges:
			side_panel.override_exp(tr("CURRENT_MODE") + "[color=" + constants.color_1 + "]" + tr("EDGES") + "[/color]\n\t" + tr("EDGES_INFO"))
			button_kanten.grab_focus()
		modes.move:
			side_panel.override_exp(tr("CURRENT_MODE") + "[color=" + constants.color_1 + "]" + tr("MOVE") + "[/color]\n\t" + tr("MOVE_INFO"))
			button_move.grab_focus()
		modes.bfs:
			side_panel.override_exp(tr("CURRENT_MODE") + "[color=" + constants.color_1 + "]" + tr("BFS") + "[/color]\n\t" + tr("BFS_INFO"))
			button_bfs.grab_focus()
		modes.dfs:
			side_panel.override_exp(tr("CURRENT_MODE") + "[color=" + constants.color_1 + "]" + tr("DFS") + "[/color]\n\t" + tr("DFS_INFO"))
			button_dfs.grab_focus()
		modes.easteregg:
			side_panel.override_exp("[tornado radius=15.0 freq=3.0 connected=1]\n\n          pick a vertex to start the [rainbow freq=2.0 sat=0.8 val=0.8]PORTAL[/rainbow] algorithm[/tornado]")

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
	# Make Info UI visible
	side_panel.reset(0, 1, 1, 1)
	side_panel.reset(1, 0, 0, 0)
	
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
	# Make Info UI invisible
	side_panel.reset(0, 1, 1, 1)
	
	# Block active buttons, unblock navigation buttons
	get_tree().call_group("buttons_active", "release_focus")
	for button: Button in get_tree().get_nodes_in_group("buttons_active"):
		button.disabled = true
		button.mouse_filter = button.MOUSE_FILTER_IGNORE
		
	for button: Button in get_tree().get_nodes_in_group("buttons_navigation"):
		button.disabled = false
		button.mouse_filter = button.MOUSE_FILTER_STOP

# Allow / Forbid vertex from moving based on input		
func control_movement():
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
# of the currently active algorithm and do some clean up/UI updates too.
# Thus every algorithm needs to support these functions:
#	'algorithm': calculate algorithm steps and return the size of the steps to display progress properly
#	'stop': Stop algorithm with clean up
#	'forward': Visualize the next step of algorithm
#	'backward': Visualize the last step of algorithm

# Start the current algorithm if not already started and make vertices moveable
func manage_algorithm():
	# To make the vertices moveable during algorithm
	if algorithm_running:
		control_movement()
		
	# Start the current algorithm if not already started	
	if not algorithm_running:
		# If the algorithm is not running, no vertex has been selected yet.
		if left_click:
			# Try to select a vertex with the graph manager
			var start_vertex = graph_manager.try_select_vertex()
			# If the selection was successful, start algorithm on selected vertex
			# (There is nothing else to select but vertices anyways)
			if start_vertex != null:
				algorithm_running = true
				navigation_mode()
				algorithm_step_count = current_algorithm.init(start_vertex) - 1
				
				# Visualize the first step
				current_step = 0
				proceed_algorithm(0)

# Stop the current algorithm
func stop_algorithm():
	side_panel.select_containers(0, 0, 0, 1)
	# Reset graph properties
	get_tree().call_group("vertex_group", "reset_visited")
	
	# Reset graph appearance
	get_tree().call_group("vertex_group", "reset_labels")
	for knoten: vertex_class in get_tree().get_nodes_in_group("vertex_group"):
		knoten.set_sprite(vertex_class.sprites.unselected)
	for i in range(vertex_class.node_count):
		get_tree().call_group("edge_group" + str(i), "reset_color")
	
	# Stop current algorithm cleanly
	current_algorithm.stop()
	
	# Clean up
	algorithm_running = false
	state_counter.text = ""
	active_mode()
	set_mode(modes.vertices)

# Proceed algorithm by steps
func proceed_algorithm(steps: int) -> void:
	current_step += steps
	
	# Check borders
	if(current_step > algorithm_step_count):
		current_step = algorithm_step_count
	if(current_step < 0):
		current_step = 0
	
	# Visualize the current step
	current_algorithm.visualize_step(current_step)
	state_counter.text = str(current_step) + "/" + str(algorithm_step_count)

# Init
func _ready():
	side_panel.select_containers(0, 0, 0, 1)
	vertex_class.node_count = 0 
	vertex_class.automatic_labeling = true
	vertex_class.lerp_speed = 25
	vertex_class.bahn = true
	
	# Set init language from config file
	var config = ConfigFile.new()
	config.load("user://config.cfg")
	TranslationServer.set_locale(config.get_value("locale", "locale"))
	# Set init mode
	set_mode(mode)

#
# Control loop
#
@export var cam: CameraManager
var egg_counter: int = 0
func _process(_delta):
	# Update user input
	left_click = Input.is_action_just_pressed("M1")
	left_click_released = Input.is_action_just_released("M1")
	right_click = Input.is_action_just_pressed("M2")
	
	# Change state based on current mode and user input.
	match mode:
		modes.vertices:
			if not Input.is_action_just_pressed("M1 Shift"):
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
			control_movement()
		
		modes.bfs:
			# Get bfs node and set it as the current_algorithm
			current_algorithm = algorithms.get_node("bfs")
			# Start the bfs if not already started and make vertices moveable
			manage_algorithm()
		
		modes.dfs:
			# Get dfs node and set it as the current_algorithm
			current_algorithm = algorithms.get_node("dfs")
			# Start the dfs if not already started and make vertices moveable
			manage_algorithm()
			
		modes.easteregg:
			# Get dfs node and set it as the current_algorithm
			current_algorithm = algorithms.get_node("easteregg")
			# Start the dfs if not already started and make vertices moveable
			manage_algorithm()
	
	if side_panel.is_open:
		cam.right_ui_margin = 660
	else:
		cam.right_ui_margin =100
	
	# HACKY STUFF BECAUSE I DONT FULLY UNDERSTAND THE AWAIT KEYWORD
	# Quality of Life Stuff	
	# The spam of "and algorithm_running" is a hacky fix to some problems that appear
	# because of await
	if Input.is_action_just_pressed("Right") and algorithm_running:
		proceed_algorithm(1)
		await get_tree().create_timer(0.25).timeout
		while Input.is_action_pressed("Right") and algorithm_running:
			await get_tree().create_timer(0.15).timeout
			if Input.is_action_pressed("Right") and algorithm_running:
				proceed_algorithm(1)
	if Input.is_action_just_pressed("Left") and algorithm_running:
		proceed_algorithm(-1)
		await get_tree().create_timer(0.25).timeout
		while Input.is_action_pressed("Left") and algorithm_running:
			await get_tree().create_timer(0.15).timeout
			if Input.is_action_pressed("Left") and algorithm_running:
				proceed_algorithm(-1)

	# Hehe
	if not algorithm_running:
		if Input.is_action_just_pressed("P"):
			if egg_counter == 0:
				egg_counter += 0
			else:
				egg_counter = 0
		if Input.is_action_just_pressed("O"):
			if egg_counter == 1:
				egg_counter += 1
			else:
				egg_counter = 0
		if Input.is_action_just_pressed("R"):
			if egg_counter == 2:
				egg_counter += 1
			else:
				egg_counter = 0
		if Input.is_action_just_pressed("T"):
			if egg_counter == 3:
				egg_counter += 1
			else:
				egg_counter = 0
		if Input.is_action_just_pressed("A"):
			if egg_counter == 4:
				egg_counter += 1
			else:
				egg_counter = 0
		if Input.is_action_just_pressed("L"):
			if egg_counter == 5:
				egg_counter += 1
			else:
				egg_counter = 0
		if egg_counter == 6:
			set_mode(modes.easteregg)
			egg_counter = 0
				
	else:
		egg_counter = 0
