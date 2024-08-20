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

# Preloard needed scenes
@onready var knoten_scene = preload("res://scenes/knoten.tscn")
@onready var kante_scene = preload("res://scenes/kante.tscn")

@export var graph_manager: Node
@export var bfs: Node

# Needed to display progress in algorithm
@export var state_counter: Label
var current_step: int = 1
var steps: int = 0

# Needed to decide what the user clicked on / selected
var mouse_pos: Vector2
@export var sweeper: Node2D

# Stores information about what the user clicked on / selected
var selected: Node = null
var selected_2: Node = null
var selected_to_move: Node = null

func _ready():	
	set_mode(mode)

func _process(_delta):
	# Get user input
	mouse_pos = get_viewport().get_mouse_position()
	var left_click: bool = Input.is_action_just_pressed("M1")
	var left_click_released: bool = Input.is_action_just_released("M1")
	var right_click: bool = Input.is_action_just_pressed("M2")
	
	# Change state based on current mode and user input
	match mode:
		modes.vertices:
			if(left_click):
				# Dont place node interacting with the upper UI
				if(mouse_pos.y > 40):
					graph_manager.add_knoten(mouse_pos)
				else:
					print("Upper UI getroffen, Knoten wird nicht platziert")
			if(right_click):
				var collider = try_select_node()
				if collider != null:
					graph_manager.rm_knoten(collider)
		modes.edges:
			if(left_click):
				update_selected()
				if selected != null && selected_2 != null:
					graph_manager.add_kante(selected, selected_2) 
					reset_selected()
					
			if(right_click):
				update_selected()
				if selected != null && selected_2 != null:
					graph_manager.rm_kante(selected, selected_2) 
					reset_selected()
		modes.move:
			if left_click:
				var collider = try_select_node()
				if collider != null:
					selected_to_move = collider
					print("Allowing node ", selected_to_move.id_, " to move")
					selected_to_move.set_move(true)
			# Forbid node from moving
			if left_click_released:
				if selected_to_move != null:
					print("Forbidding node ", selected_to_move.id_, " to move")
					selected_to_move.set_move(false)
					selected_to_move = null
		modes.bfs:
			if left_click:
				var collider = try_select_node()
				if collider != null:
					get_tree().call_group("buttons_active", "release_focus")
					current_step = 0
					steps = bfs.breitensuche(collider) - 1
					state_counter.text = str(current_step) + "/" + str(steps)
					navigation_mode()

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
	for button: Button in get_tree().get_nodes_in_group("buttons_active"):
		button.disabled = false
		button.mouse_filter = button.MOUSE_FILTER_STOP
		
	for button: Button in get_tree().get_nodes_in_group("buttons_navigation"):
		button.disabled = true
		button.mouse_filter = button.MOUSE_FILTER_IGNORE

# Unblock navigation buttons, unblock active button
func navigation_mode():
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
			display.set_text("Current mode: [color=" + constants.uni_blau + "]VERTICES[/color]\n\t- Left click on grey area to add a vertex\n\t- Right click on a vertex to remove it")
			button_knoten.grab_focus()
		modes.edges:
			display.set_text("Current mode: [color=" + constants.uni_blau + "]EDGES[/color]\n\t- Left click on two vertices to add an edge between them\n\t- Right click on two vertices to remove edge between them")
		modes.move:
			display.set_text("Current mode: [color=" + constants.uni_blau + "]MOVE[/color]\n\t- Select and drag a vertex to move it")
		modes.bfs:
			display.set_text("Current mode: [color=" + constants.uni_blau + "]BFS[/color]\n\t- Select a vertex s to start a breadth-first search starting from it")
		modes.dfs:
			display.set_text("NOT YET IMPLEMENTED :(")

# I should try to move these to the graph manager sometime
# Tries to select a node at the position of the mouse. Returns the selected node or null in case of failure
func try_select_node() -> Node:
	# Teleport the sweeper to mouse_pos and check if it hits anything
	sweeper.set_global_position(mouse_pos)
	sweeper.enabled = true
	sweeper.force_shapecast_update()
	
	if !sweeper.is_colliding():
		print("Sweeper collided mit nichts, resete Auswahl")
		sweeper.enabled = false
		reset_selected()
		return null
	
	var collider = sweeper.get_collider(0)
	if collider.is_in_group("knoten_menge"):
		return collider
		
	print("Sweeper collided mit etwas, jedoch mit keinem Knoten")
	return null

# Updates the last two selected nodes and possibly their sprite. Important for edges mode .
func update_selected():
	var collider = try_select_node()
	
	if collider != null:
		if selected == null:
			print("New Selected ", collider.id_)
			selected = collider
			collider.set_sprite(knoten_klasse.sprites.selected)
			return
		
		print("New Selected_2 ", collider.id_)
		selected_2 = collider
		return

# Reset selected nodes and their sprites
func reset_selected():
	if selected != null:
		selected.set_sprite(knoten_klasse.sprites.unselected)
	if selected_2 != null:
		selected_2.set_sprite(knoten_klasse.sprites.unselected)
	selected = null
	selected_2 = null
