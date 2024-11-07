extends Control

var scene_man = scene_manager.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(scene_man)
	
	# Create new ConfigFile object.
	var config = ConfigFile.new()
	config.load("user://config.cfg")
	
	# Locale already choosen, go to main
	if config.has_section("locale"):
		if config.get_value("locale", "has_choosen") == true:
			scene_man.change_scene("select_topic")
			return
	
	# Save defaults
	config.set_value("locale", "locale", "en")
	config.set_value("locale", "has_choosen", false)
	config.save("user://config.cfg")

func pick_en():
	helper_functions.select_locale("en")
	scene_man.change_scene("select_topic")
	
func pick_de():
	helper_functions.select_locale("de")
	scene_man.change_scene("select_topic")
