extends Node

var mode: int = 0

@onready var knoten_scene = preload("res://scenes/knoten.tscn")
@onready var kante_scene = preload("res://scenes/kante.tscn")

var graph_manager: Node
var algorithms: Node

var selected: Node = null
var selected_2: Node = null
var selected_to_move: Node = null

var mouse_pos: Vector2
var sweeper: Node2D
var sweeper_klein: Node2D

var states: Array = []

func _ready():
	graph_manager = get_node("graph_manager")
	algorithms = get_node("algorithms")
	sweeper = get_node("sweeper")
	sweeper_klein = get_node("sweeper_klein")
	
	set_mode(0)
	
func _process(_delta):
	mouse_pos = get_viewport().get_mouse_position()
	var left_click: bool = Input.is_action_just_pressed("M1")
	var left_click_released: bool = Input.is_action_just_released("M1")
	var right_click: bool = Input.is_action_just_pressed("M2")
	
	match mode:
		# Mode 0 - Placing and removing nodes
		0:
			if(left_click):
				# Dont place node interacting with the upper UI
				if(mouse_pos.y > 40):
					graph_manager.add_knoten(mouse_pos)
				else:
					print("Das hinzufügen eines Knotens ist fehlgeschlagen")
					
			if(right_click):
				var collider = try_select_node()
				if collider != null:
					graph_manager.rm_knoten(collider)
					
		# Mode 1 - Placing and removing edges
		1:
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
					
		# Mode 2 - Moving nodes
		2:
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
					
		# Mode 3 - Breitensuche
		3:
			if left_click:
				var collider = try_select_node()
				if collider != null:
					set_mode(-1)
					algorithms.breitensuche(collider)

# Tries to select a node at the position of the mouse. Returns  the selected node or null in case of failure
func try_select_node() -> Node:
	# Teleport the sweeper to mouse_pos and check, if it hits anything
	sweeper_klein.set_global_position(mouse_pos)
	sweeper_klein.enabled = true
	sweeper_klein.force_shapecast_update()
	
	if !sweeper_klein.is_colliding():
		print("Kleiner Sweeper collided mit nichts, resete Auswahl")
		sweeper_klein.enabled = false
		reset_selected()
		return null
	
	var collider = sweeper_klein.get_collider(0)
	if collider.is_in_group("knoten_menge"):
		return collider
		
	print("Kleiner Sweeper collided mit etwas, jedoch mit keinem Knoten")
	return null

# Updates the last two selected nodes and ggf. their sprite. Important for mode 1 (Kanten-mode).
func update_selected():
	var collider = try_select_node()
	
	if collider != null:
		if selected == null:
			print("New Selected ", collider.id_)
			selected = collider
			collider.set_sprite(2)
			return
		
		print("New Selected_2 ", collider.id_)
		selected_2 = collider
		return

# Reset selected nodes and their sprites
func reset_selected():
	if selected != null:
		selected.set_sprite(1)
	if selected_2 != null:
		selected_2.set_sprite(1)
	selected = null
	selected_2 = null

@export var display: RichTextLabel
@export var button_knoten: Button
# Set current mode and info text accordingly
func set_mode(mode_: int):
	mode = mode_
	match mode:
		0:
			display.set_text("Current mode: [color=" + constants.uni_blau + "]VERTICES[/color]\n\t- Left click on grey area to add a vertex\n\t- Right click on a vertex to remove it")
			button_knoten.grab_focus()
		1:
			display.set_text("Current mode: [color=" + constants.uni_blau + "]EDGES[/color]\n\t- Left click on two vertices to add an edge between them\n\t- Right click on two vertices to remove edge between them")
		2:
			display.set_text("Current mode: [color=" + constants.uni_blau + "]MOVE[/color]\n\t- Select and drag a vertex to move it")
		3:
			display.set_text("Current mode: [color=" + constants.uni_blau + "]BFS[/color]\n\t- Select a vertex s to start a breadth-first search starting from it")
		4:
			display.set_text("NOT YET IMPLEMENTED :(")
		-1:
			get_tree().call_group("buttons_active", "release_focus")
