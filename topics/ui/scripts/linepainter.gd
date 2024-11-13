extends RichTextLabel

var color = constants.color_1
var init_text = ""

func highlight_lines(lines_to_paint: Array) -> void:
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
