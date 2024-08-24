extends OptionButton

func _ready():
	TranslationServer.set_locale("de")

func _on_item_selected(index):
	match index:
		0:
			TranslationServer.set_locale("de")
		1:
			TranslationServer.set_locale("en")
