extends HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create new ConfigFile object.
	var config = ConfigFile.new()
	config.load("user://config.cfg")
	
	# Locale already choosen, go to main
	if config.has_section("locale"):
		get_tree().call_deferred("change_scene_to_file", "res://menus/select_topic/select_topic.tscn")
		return
	
	# Save defaults
	config.set_value("locale", "locale", "en")
	config.set_value("locale", "has_choosen", false)
	config.save("user://config.cfg")

func _process(_delta):
	var config = ConfigFile.new()
	config.load("user://config.cfg")
	print(config.get_value("locale", "locale"))

func pick_locale(locale: String):
	var config = ConfigFile.new()
	config.load("user://config.cfg")
	config.set_value("locale", "locale", locale)
	config.set_value("locale", "has_choosen", true)
	config.save("user://config.cfg")
	get_tree().call_deferred("change_scene_to_file", "res://menus/select_topic/select_topic.tscn")

func pick_en():
	pick_locale("en")
	
func pick_de():
	pick_locale("de")
