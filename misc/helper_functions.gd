class_name helper_functions extends Node

static func vertex_array_to_string(array: Array) -> String:
	if array.is_empty():
		return "[]"
		
	var string: String = "["
	for vertex: vertex_class in array:
		string += str(vertex.id_)
		string += ", "
	string = string.erase(string.length() - 2, 2)
	string += "]"
	return string
