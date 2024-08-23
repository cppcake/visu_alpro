extends Button
@export var controller: Node

func _on_pressed():
	get_tree().call_group("vertex_group", "queue_free")
	controller.set_mode(controller.modes.vertices)
	
	for id in range(vertex_class.node_count):
		get_tree().call_group("edge_group" + str(id), "queue_free")
		
	vertex_class.node_count = 0
