class_name ExpContainer extends MarginContainer

@export var exp_display: RichTextLabel
func override(text_):
	exp_display.text = text_

func reset():
	exp_display.text = ""
