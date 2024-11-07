extends RichTextLabel

var color = constants.uni_blau
var numbers_of_painted_lines = []

func highlight_state(numbers_of_lines_to_paint: Array):
	for line_nr in numbers_of_painted_lines:
		unpaint_line(line_nr)
	
	for line_nr in numbers_of_lines_to_paint:
		paint_line(line_nr)
	
	numbers_of_painted_lines = numbers_of_lines_to_paint

func paint_line(line_nr: int) -> void:
	replace_line(line_nr, ("[color=" + color + "]" + get_line(line_nr) + "[/color]"))

func unpaint_line(line_nr: int) -> void:
	replace_line(line_nr, get_line(line_nr).lstrip("[color=" + color + "]").rstrip("[/color]"))
	
func get_line(line_nr) -> String:
	var lines = get_text().split('\n', false)
	if !lines.is_empty():
		return lines[line_nr - 1]
	return ""

func replace_line(line_nr: int, new_line: String) -> void:
	var lines = get_text().split('\n', false)
	if lines.size() >= line_nr:
		lines[line_nr - 1] = new_line
		
	var new_text = ""
	for line in lines:
		new_text += line + '\n'
		
	set_text(new_text)
