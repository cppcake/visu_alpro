class_name CodeContainer extends MarginContainer

@export var code_displayer_holder: MarginContainer
@export var code_display: RichTextLabel
@export var label_call: Label
@export var label_return: Label
func override(text_, update_init: bool):
	code_display.lines_history = [[]]
	code_display.text = highlight_syntax(text_)
	if update_init:
		code_display.init_text = highlight_syntax(text_)
	custom_minimum_size.y = code_displayer_holder.adjust_min_size() + 140

var call_history = [""]
func set_call(text_):
	call_history.push_back(text_)
	label_call.text = call_history.back()
func set_call_undo():
	call_history.pop_back()
	label_call.text = call_history.back()

var return_history = [""]
var color_history = [Color.WHITE]
# TRASH CODE
func set_return_v2(return_value, color: Color = constants.color_1_c):
	if return_value is int:
		if return_value == 39:
			return_history.push_back("")
			label_return.text = return_history.back()
			color_history.push_back(Color.WHITE)
			label_return.modulate = color_history.back()
			return
	
	if return_value == null:
		return_history.push_back(tr("TERMINATE_2"))
	else:
		return_history.push_back(tr("TERMINATE") + str(return_value))
	label_return.text = return_history.back()
	color_history.push_back(color)
	label_return.modulate = color_history.back()
func set_return_v2_undo():
	return_history.pop_back()
	label_return.text = return_history.back()
	
	color_history.pop_back()
	label_return.modulate = color_history.back()
func crash():
	label_return.text = "Segmentation fault (core dumped)"
	label_return.modulate = Color.RED
func crash_undo():
	label_return.text = ""

func highlight_lines(lines: Array):
	code_display.highlight_lines(lines)
func highlight_lines_undo():
	code_display.highlight_lines_undo()

func highlight_syntax(text_: String) -> String:
	var dict = {\
				["if", "else", "for", "return", "func", "do", "while", "and", "int", "break"] : "[b]"\
				,["(", ")"] : "[b]"\
				,["{", "}"] : "[b]"}

	for keyword_list: Array in dict:
		for keyword: String in keyword_list:
			text_ = text_.replace(keyword, dict[keyword_list] + keyword + "[/b]")

	return text_

func reset():
	code_display.text = ""
	label_call.text = ""
	label_return.text = ""
	call_history = [""]
	return_history = [""]
	color_history = [Color.WHITE]
	code_displayer_holder.adjust_min_size()

# Legacy stuff
func set_return(text_, color: Color = constants.color_main):
	label_return.modulate = color
	label_return.text = text_
