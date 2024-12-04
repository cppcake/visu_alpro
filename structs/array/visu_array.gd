class_name VisuArray extends HBoxContainer

@export var array_name = ""
@export var label_name: Label
func _ready():
	label_name.text = array_name + ": "

@export var array_entry_scene: PackedScene
@export var ArrayEntriesHolder: HBoxContainer
var array_history: Array = [[]]
func visu_array(array: Array, save: bool = true):
	if save:
		array_history.push_back(array.duplicate())
	
	# Queue free every old array entry
	for child in ArrayEntriesHolder.get_children():
		child.queue_free()
	
	var index = 0
	for element in array:
		var entry = array_entry_scene.instantiate()
		entry.set_label_data(str(element))
		entry.set_label_index(index)
		index += 1
		ArrayEntriesHolder.add_child(entry)

func visu_array_undo():
	array_history.pop_back()
	visu_array(array_history.back(), false)
