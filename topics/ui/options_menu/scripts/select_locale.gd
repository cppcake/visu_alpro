extends OptionButton

func update_selected():
	var config = ConfigFile.new()
	config.load("user://config.cfg")
	if config.has_section("locale"):
		match config.get_value("locale", "locale"):
			"en":
				selected = 0
			"de":
				selected = 1

func _on_item_selected(index):
	var scene_man = scene_manager.new()
	add_child(scene_man)
	match index:
		0:
			helper_functions.select_locale("en")
		1:
			helper_functions.select_locale("de")
	
	scene_man.change_scene("select_topic")
