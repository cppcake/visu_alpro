extends Node

@onready var knoten_scene = preload("res://scenes/knoten.tscn")
@onready var kante_scene = preload("res://scenes/kante.tscn")

# Needed to decide what the user clicked on / selected
var mouse_pos: Vector2
@export var sweeper: Node2D

# Stores information about what the user clicked on / selected
var selected: Node = null
var selected_2: Node = null
var selected_to_move: Node = null

func add_knoten(pos: Vector2) -> void:
		print("Ein Knoten wird hinzugefügt an ", pos)
		var knoten_instanz = knoten_scene.instantiate()
		knoten_instanz.set_global_position(pos)
		knoten_instanz.add_to_group("knoten_menge")
		add_child(knoten_instanz)

func add_vertex_at_mouse_pos() -> void:
	mouse_pos = get_viewport().get_mouse_position()
	if(mouse_pos.y > constants.upper_ui_margin - 60):
		add_knoten(mouse_pos)
	else:
		print("Upper UI getroffen, Knoten wird nicht platziert")

func rm_knoten(knoten: Node) -> void:
	print("Knoten ", knoten.id_, " wird entfernt")
	for i in range(knoten_klasse.node_count):
		for kante in get_tree().get_nodes_in_group("kanten_menge" + str(i)):
			if kante.ziel_knoten.id_ == knoten.id_ or kante.start_knoten.id_ == knoten.id_:
				kante.queue_free()
	knoten.queue_free()

func remove_vertex_at_mouse_pos() -> void:
	var collider = try_select_node()
	if collider != null:
		rm_knoten(collider)

func get_knoten_by_id(id_knoten):
	for knoten in get_tree().get_nodes_in_group("knoten_menge"):
		if knoten.id_ == id_knoten:
			return knoten
	return null

func add_kante(start, ziel) -> void:
	for kante in get_tree().get_nodes_in_group("kanten_menge" + str(start.id_)):
		if kante.ziel_knoten.id_ == ziel.id_:
			print("Die Kante ", start.id_, " zu ", ziel.id_, " existiert bereits!")
			return
			
	print("Eine Kante wird hinzugefügt von ", start.id_, " zu ", ziel.id_)
	var kanten_instanz = kante_scene.instantiate()
	kanten_instanz.start_knoten = start
	kanten_instanz.ziel_knoten = ziel
	
	for kante in get_tree().get_nodes_in_group("kanten_menge" + str(ziel.id_)):
		if kante.ziel_knoten.id_ == start.id_:
			# Counteredge exists, displace both edges affected and redraw  the already existing one
			kanten_instanz.displacement = true
			kante.displacement = true
			kante.draw()
			break
			
	kanten_instanz.add_to_group("kanten_menge" + str(start.id_))
	add_child(kanten_instanz)
	kanten_instanz.draw()

func add_edge_between_selected() -> void:
	update_selected()
	if selected != null && selected_2 != null:
		add_kante(selected, selected_2) 
		reset_selected()

func rm_kante(start, ziel) -> void:
	# Die Laufzeit ist trotzdem in O(n), also alles gut :P
	for kante in get_tree().get_nodes_in_group("kanten_menge" + str(start.id_)):
		if kante.ziel_knoten == ziel:
			# Displacement der Gegenkante ggf. entfernen
			for kante_ in get_tree().get_nodes_in_group("kanten_menge" + str(ziel.id_)):
				if kante_.ziel_knoten.id_ == start.id_:
					# Counter edge existed. Undo displacement and redraw it.
					kante_.displacement = false
					kante_.draw()
					print("Gegenkante wurde zurückgesetzt!")
					break
			print("Kante (", start.id_, ", ", ziel.id_, ") wird entfernt")
			kante.queue_free()
			return
	print("Kantenentfernung nicht erfolgreich ", start.id_, " zu ", ziel.id_)

func rm_edge_between_selected() -> void:
	update_selected()
	if selected != null && selected_2 != null:
		rm_kante(selected, selected_2) 
		reset_selected()

func allow_node_at_mouse_pos_to_move() -> void:
	var collider = try_select_node()
	if collider != null:
		selected_to_move = collider
		print("Allowing node ", selected_to_move.id_, " to move")
		selected_to_move.set_move(true)

func forbid_node_at_mouse_pos_to_move() -> void:
	if selected_to_move != null:
		print("Forbidding node ", selected_to_move.id_, " to move")
		selected_to_move.set_move(false)
		selected_to_move = null

func try_select_node() -> Node:
	mouse_pos = get_viewport().get_mouse_position()
	
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
