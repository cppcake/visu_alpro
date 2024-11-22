extends RichTextLabel

var color = constants.color_1
var init_text = ""

var lines_history = []
func highlight_lines(lines_to_paint: Array, push: bool = true) -> void:
	if push:
		lines_history.append(lines_to_paint)
	text = init_text
	# Split the label's text by lines
	var lines = text.split("\n")

	# Iterate through each index in the array
	for i in lines_to_paint:
		# Check if the index is within the bounds of the lines array
		if i >= 0 and i < lines.size() + 1:
		# Modify the line with the front and back strings
			lines[i - 1] = ("[color=" + color + "]") + lines[i - 1] + "[/color]"

	# Join the lines back together and set the label's text
	text = "\n".join(lines)
func highlight_lines_undo() -> void:
	if lines_history.size() > 1:
		lines_history.pop_back()
	else:
		highlight_lines([], false)
		return
	
	if lines_history.size() > 0:
		highlight_lines(lines_history.back(), false)
	else:
		highlight_lines([], false)
