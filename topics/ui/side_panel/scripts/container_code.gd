class_name CodeContainer extends MarginContainer

@export var code_display: RichTextLabel
@export var label_return: Label
func override(text_):
	code_display.text = text_
	code_display.init_text = text_
	
func set_return(text_):
	label_return.text = text_

func reset():
	code_display.text = ""
	label_return.text = ""

func highlight_lines(lines: Array):
	code_display.highlight_lines(lines)
