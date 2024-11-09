extends Label

func update_state_counter(current_step: int, max_step: int):
	text = str(current_step) + " / " + str(max_step)
