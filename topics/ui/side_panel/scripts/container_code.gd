class_name CodeContainer extends MarginContainer

@export var code_display: RichTextLabel
@export var label_call: Label
@export var label_return: Label
func override(text_, update_init: bool):
	code_display.text = text_
	if update_init:
		code_display.init_text = text_

func set_call(text_):
	label_call.text = text_

func set_return(text_, color: Color = constants.color_1_c):
	label_return.modulate = color
	label_return.text = text_

func reset():
	code_display.text = ""
	label_call.text = ""
	label_return.text = ""

func highlight_lines(lines: Array):
	code_display.highlight_lines(lines)
