extends tree_vertex_class

# EFFICIENZY
# STUPID WORK AROUNDS BECAUSE I DONT HAVE ANY TIME :sob:
func _process(delta):
	if reference_counter == 0:
		visible = false
	
	if p1.target == null or p1.target.visible == false:
		p1.visible = false
	else:
		p1.visible = true
	
	if p2.target == null or p2.target.visible == false:
		p2.visible = false
	else:
		p2.visible = true
