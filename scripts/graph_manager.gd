extends Node

@onready var knoten_scene = preload("res://scenes/knoten.tscn")
@onready var kante_scene = preload("res://scenes/kante.tscn")

func add_knoten(pos: Vector2) -> void:
		print("Ein Knoten wird hinzugefügt an ", pos)
		var knoten_instanz = knoten_scene.instantiate()
		knoten_instanz.set_global_position(pos)
		knoten_instanz.add_to_group("knoten_menge")
		add_child(knoten_instanz)

func rm_knoten(knoten: Node) -> void:
	print("Knoten ", knoten.id_, " wird entfernt")
	for i in range(knoten_klasse.node_count):
		for kante in get_tree().get_nodes_in_group("kanten_menge" + str(i)):
			if kante.ziel_knoten.id_ == knoten.id_ or kante.start_knoten.id_ == knoten.id_:
				kante.queue_free()
	knoten.queue_free()

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
