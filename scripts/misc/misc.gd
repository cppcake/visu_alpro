class_name misc extends Node

static func int_array_to_string(array: Array) -> String:
	if array.is_empty():
		return "[]"
		
	var string: String = "["
	for knoten: Node in array:
		string += str(knoten.id_)
		string += ", "
	string = string.erase(string.length() - 2, 2)
	string += "]"
	return string
