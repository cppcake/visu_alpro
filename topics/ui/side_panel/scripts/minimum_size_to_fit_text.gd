extends Control

@export var rich_text_label: RichTextLabel
@export var pixel_per_line: int = 24
@export var max_screen_height_cover: float = 0.4

func adjust_min_size():
	# Get the line count
	var line_count = rich_text_label.get_line_count()

	# Calculate the required height
	var required_height = line_count * pixel_per_line + 10
	
	var screen_height: float = get_viewport().get_visible_rect().size[1]
	if required_height > screen_height * max_screen_height_cover:
		required_height = screen_height * max_screen_height_cover
	
	# Adjust the minimum size
	custom_minimum_size.y = required_height
