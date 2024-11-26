extends Label

var text_history = [""]
func overwrite(text_: String):
	text = text_
	text_history.push_back(text_)
func overwrite_undo():
	text_history.pop_back()
	text = text_history.back()
