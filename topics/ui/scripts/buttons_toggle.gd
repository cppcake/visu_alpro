extends Button

func _on_pressed():
	if is_in_group("buttons_active"):
		# Block active buttons, unblock navigation buttons
		get_tree().call_group("buttons_active", "release_focus")
		for button: Control in get_tree().get_nodes_in_group("buttons_active"):
			if button is Button:
				button.disabled = true
			button.mouse_filter = button.MOUSE_FILTER_IGNORE
			
		for button: Control in get_tree().get_nodes_in_group("buttons_navigation"):
			if button is Button:
				button.disabled = false
			button.mouse_filter = button.MOUSE_FILTER_STOP
	
	if is_in_group("buttons_navigation"):
		# Unblock active buttons, block navigation buttons
		get_tree().call_group("buttons_navigation", "release_focus")
		for button: Control in get_tree().get_nodes_in_group("buttons_active"):
			if button is Button:
				button.disabled = false
			button.mouse_filter = button.MOUSE_FILTER_STOP
			
		for button: Button in get_tree().get_nodes_in_group("buttons_navigation"):
			if button is Button:
				button.disabled = true
			button.mouse_filter = button.MOUSE_FILTER_IGNORE
