extends Button
@export var controller: Node

func _on_pressed():
	get_tree().call_group("knoten_menge", "queue_free")
	controller.set_mode(0)
	
	for i in range(knoten_klasse.node_count):
		get_tree().call_group("kanten_menge" + str(i), "queue_free")
		
	knoten_klasse.node_count = 0
