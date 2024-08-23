extends Node

@onready var vertex_scene = preload("res://scenes/vertex.tscn")
@onready var edge_scene = preload("res://scenes/edge.tscn")

# Needed to decide what the user clicked on / selected
var mouse_pos: Vector2
@export var sweeper: Node2D

# Stores information about what the user clicked on / selected
var selected: Node = null
var selected_2: Node = null
var selected_to_move: Node = null

func add_vertex(pos: Vector2) -> void:
		print("Vertex will be added at ", pos)
		var vertex_instance = vertex_scene.instantiate()
		vertex_instance.set_global_position(pos)
		vertex_instance.add_to_group("vertex_group")
		add_child(vertex_instance)

func add_vertex_at_mouse_pos() -> void:
	mouse_pos = get_viewport().get_mouse_position()
	if(mouse_pos.y > constants.upper_ui_margin - 60):
		add_vertex(mouse_pos)
	else:
		print("Hitting upper UI, vertex wont be placed")

func rm_vertex(vertex: Node) -> void:
	print("Removing Vertex ", vertex.id_)
	for i in range(knoten_klasse.node_count):
		for edge in get_tree().get_nodes_in_group("edge_group" + str(i)):
			if edge.ziel_knoten.id_ == vertex.id_ or edge.start_knoten.id_ == vertex.id_:
				edge.queue_free()
	vertex.queue_free()

func remove_vertex_at_mouse_pos() -> void:
	var collider = try_select_vertex()
	if collider != null:
		rm_vertex(collider)

func get_vertex_by_id(vertex_id):
	for vertex in get_tree().get_nodes_in_group("vertex_group"):
		if vertex.id_ == vertex_id:
			return vertex
	return null

func add_edge(start, target) -> void:
	for edge in get_tree().get_nodes_in_group("edge_group" + str(start.id_)):
		if edge.ziel_knoten.id_ == target.id_:
			print("Edge from vertex ", start.id_, " to vertex ", target.id_, " already exists")
			return
			
	print("Adding edge between vertex ", start.id_, " and vertex ", target.id_)
	var edge_instance = edge_scene.instantiate()
	edge_instance.start_knoten = start
	edge_instance.ziel_knoten = target
	
	for edge in get_tree().get_nodes_in_group("edge_group" + str(target.id_)):
		if edge.ziel_knoten.id_ == start.id_:
			# Counteredge exists, displace both edges affected and redraw  the already existing one
			edge_instance.displacement = true
			edge.displacement = true
			break
			
	edge_instance.add_to_group("edge_group" + str(start.id_))
	add_child(edge_instance)

func add_edge_between_selected() -> void:
	update_selected()
	if selected != null && selected_2 != null:
		add_edge(selected, selected_2) 
		reset_selected()

func rm_edge(start, target) -> void:
	# Die Laufzeit ist trotzdem in O(n), also alles gut :P
	for edge in get_tree().get_nodes_in_group("edge_group" + str(start.id_)):
		if edge.ziel_knoten == target:
			# Displacement der Gegenkante ggf. entfernen
			for edge_ in get_tree().get_nodes_in_group("edge_group" + str(target.id_)):
				if edge_.ziel_knoten.id_ == start.id_:
					# Counter edge existed. Undo displacement and redraw it.
					edge_.displacement = false
					edge_.draw()
					print("Gegenkante wurde zurückgesetzt!")
					break
			print("Removing edge between vertex ", start.id_, " and vertex ", target.id_)
			edge.queue_free()
			return
	print("Edge from vertex ", start.id_, " to vertex ", target.id_, " does not exist")

func rm_edge_between_selected() -> void:
	update_selected()
	if selected != null && selected_2 != null:
		rm_edge(selected, selected_2) 
		reset_selected()

func allow_vertex_at_mouse_pos_to_move() -> void:
	var collider = try_select_vertex()
	if collider != null:
		selected_to_move = collider
		print("Allowing vertex ", selected_to_move.id_, " to move")
		selected_to_move.set_move(true)

func forbid_vertex_at_mouse_pos_to_move() -> void:
	if selected_to_move != null:
		print("Forbidding vertex ", selected_to_move.id_, " to move")
		selected_to_move.set_move(false)
		selected_to_move = null

func try_select_vertex() -> Node:
	mouse_pos = get_viewport().get_mouse_position()
	
	# Teleport the sweeper to mouse_pos and check if it hits anything
	sweeper.set_global_position(mouse_pos)
	sweeper.enabled = true
	sweeper.force_shapecast_update()
	
	if !sweeper.is_colliding():
		print("Sweeper does not collide with a vertex, reset selection")
		sweeper.enabled = false
		reset_selected()
		return null
	
	var collider = sweeper.get_collider(0)
	if collider.is_in_group("vertex_group"):
		return collider
	
	print("Sweeper did collide with a non-vertex, break")
	return null

# Updates the last two selected nodes and possibly their sprite. Important for edges mode .
func update_selected():
	var collider = try_select_vertex()
	
	if collider != null:
		if selected == null:
			print("New selected ", collider.id_)
			selected = collider
			collider.set_sprite(knoten_klasse.sprites.selected)
			return
		
		print("New selected_2 ", collider.id_)
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
