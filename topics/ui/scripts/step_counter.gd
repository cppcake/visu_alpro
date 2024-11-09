extends Label

func update_step_label(current_step: int, max_step: int):
	text = str(current_step) + " / " + str(max_step)
