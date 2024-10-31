class_name GraphManager extends Node

@onready var vertex_scene = preload("res://scenes/vertex.tscn")
@onready var edge_scene = preload("res://scenes/edge.tscn")

# Needed to decide what the user clicked on / selected
@export var camera: Camera2D
@export var sweeper: Node2D

# Stores information about what the user clicked on / selected
var selected: vertex_class = null
var selected_2: vertex_class = null
var selected_to_move: vertex_class = null

func add_vertex(pos: Vector2) -> void:
		print("Vertex will be added at ", pos)
		var vertex_instance = vertex_scene.instantiate()
		vertex_instance.set_global_position(pos)
		vertex_instance.add_to_group("vertex_group")
		add_child(vertex_instance)

func add_vertex_at_mouse_pos() -> void:
	if(camera.is_over_playground()):
		add_vertex(camera.get_world_pos())
	else:
		print("Hitting UI, vertex wont be placed")

func rm_vertex(vertex: vertex_class) -> void:
	print("Removing Vertex ", vertex.id_)
	# Iterate through all edges and remove all edges connected to/from the vertex
	# Inefficient but it works reliably and fast enough to not be noticed whatsoever
	for i in range(vertex_class.node_count):
		for edge in get_tree().get_nodes_in_group("edge_group" + str(i)):
			if edge.target_vertex.id_ == vertex.id_ or edge.start_vertex.id_ == vertex.id_:
				edge.queue_free()
	# Remove the vertex
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
		if edge.target_vertex.id_ == target.id_:
			print("Edge from vertex ", start.id_, " to vertex ", target.id_, " already exists")
			return
			
	print("Adding edge between vertex ", start.id_, " and vertex ", target.id_)
	var edge_instance = edge_scene.instantiate()
	edge_instance.start_vertex = start
	edge_instance.target_vertex = target
	
	for edge in get_tree().get_nodes_in_group("edge_group" + str(target.id_)):
		if edge.target_vertex.id_ == start.id_:
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
		if edge.target_vertex == target:
			# Displacement der Gegenkante ggf. entfernen
			for edge_ in get_tree().get_nodes_in_group("edge_group" + str(target.id_)):
				if edge_.target_vertex.id_ == start.id_:
					# Counter edge existed. Undo displacement
					print("Reset counteredge")
					edge_.displacement = false
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
		selected_to_move.set_allowed_to_move(true)

func forbid_vertex_at_mouse_pos_to_move() -> void:
	if selected_to_move != null:
		print("Forbidding vertex ", selected_to_move.id_, " to move")
		selected_to_move.set_allowed_to_move(false)
		selected_to_move = null

func try_select_vertex() -> vertex_class:
	# Teleport the sweeper to mouse_pos in world coordinates and check if it hits anything
	sweeper.set_global_position(camera.get_world_pos())
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
			collider.set_sprite(vertex_class.sprites.selected)
			return
		
		print("New selected_2 ", collider.id_)
		selected_2 = collider
		return

# Reset selected nodes and their sprites
func reset_selected():
	if selected != null:
		selected.set_sprite(vertex_class.sprites.unselected)
	if selected_2 != null:
		selected_2.set_sprite(vertex_class.sprites.unselected)
	selected = null
	selected_2 = null
