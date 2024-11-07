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
	
static func select_locale(locale: String):
	var config = ConfigFile.new()
	config.load("user://config.cfg")
	config.set_value("locale", "locale", locale)
	config.set_value("locale", "has_choosen", true)
	config.save("user://config.cfg")
	TranslationServer.set_locale(locale)
