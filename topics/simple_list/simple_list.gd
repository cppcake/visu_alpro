extends Node

@export var graph_manager: GraphManager
@export var camera: CameraManager
var vector: vertex_class

@export var corona_distance: int = 250
var head: vertex_class
var null_: vertex_class
var names: Array
var positions: Array
var vertices: Array
# Called when the node enters the scene tree for the first time.
func _ready():
	vertex_class.automatic_labeling = false
	vertex_class.lerp_speed = 5
	vertex_class.bahn = false
	
	head = graph_manager.add_vertex(Vector2(0, 0))
	head.sprite.visible = false
	null_ = graph_manager.add_vertex(Vector2(0, 0))
	null_.sprite.visible = false
	
	for i in range(3):
		vertices.append(graph_manager.add_vertex(Vector2(i * corona_distance, 0)))
		names.append(str(i) + "xd")
		positions.append(Vector2(i * corona_distance, 0))
	recreate_list()

var current_step = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var left_click = Input.is_action_just_pressed("M1")
	if left_click:
		current_step = current_step + 1
		insert_front_forward(current_step, "xD")
	
	var right_click = Input.is_action_just_pressed("M2")
	if right_click:
		insert_front_backward(current_step)
		current_step = current_step - 1
		
	var middle_click = Input.is_action_just_pressed("M3")
	if middle_click:
		pass
		

func recreate_list():
	# Clear current graph
	graph_manager.clear()
	vertices.clear()
	
	# Add head and null pointers
	head = graph_manager.add_vertex(Vector2(0, 0))
	head.sprite.visible = false
	null_ = graph_manager.add_vertex(Vector2(0, 0))
	null_.sprite.visible = false
	
	# Recreate old vertices
	for i in range(names.size()):
		vertices.append(graph_manager.add_vertex(positions[i]))

	reposition_vertices()
	reposition_head_tail()
	redraw_pointers()
	redraw_labels()

func reposition_vertices():
	var n = vertices.size()
	for i in range(n):
		vertices[i].position = positions[i]
	
func reposition_head_tail():
	var n = vertices.size()
	head.position = Vector2(vertices[0].position.x - 110, -110)
	null_.position = Vector2(vertices[n - 1].position.x + 150, 150)

func redraw_pointers():
	var n = vertices.size()
	for i in range(n):
		if i != n - 1:
			graph_manager.add_edge(vertices[i], vertices[i + 1])
	graph_manager.add_edge(head, vertices[0])
	graph_manager.add_edge(vertices[n - 1], null_)

func redraw_labels():
	var n = vertices.size()
	for i in range(n):
		vertices[i].label_id.text = names[i]
	
	head.label_id.text = "Head"
	head.label_id.position = Vector2(-25, -25)
	null_.label_id.text = "null"
	null_.label_id.position = Vector2(-50, -40)	

var new_vertex: vertex_class
var invis: vertex_class
func insert_front_forward(step: int, data: String):
	match step:
		1:
			new_vertex = graph_manager.add_vertex(Vector2(vertices[0].position.x - 100, 200))
			new_vertex.label_id.text = data
			invis = graph_manager.add_vertex(Vector2(vertices[0].position.x + 100, 200))
			invis.visible = false
			graph_manager.add_edge(new_vertex, invis)
	
		2:
			# Step 2 - let new vertex point at vertex pointed at by head
			invis.move_to(vertices[0].position)

		3:
			graph_manager.rm_edge(new_vertex, invis)
			graph_manager.add_edge(new_vertex, vertices[0])
			# Step 3 - make head point at the new vertex
			graph_manager.rm_edge(head, vertices[0])
			graph_manager.add_edge(head, invis)
			invis.move_to(new_vertex.position)
			
			
		4:
			graph_manager.rm_edge(head, invis)
			graph_manager.add_edge(head, new_vertex)
			# Step 4 - repositon
			new_vertex.move_to(Vector2(vertices[0].position.x - corona_distance, 0))
			vertices.push_front(new_vertex)
			reposition_head_tail()

func insert_front_backward(step: int):
	match step:
		1:
			# Step 1 - create vertex pointing into nothing
			graph_manager.rm_vertex(new_vertex)
	
		2:
			# Step 2 - let new vertex point at vertex pointed at by head
			graph_manager.add_edge(new_vertex, invis)
			graph_manager.rm_edge(new_vertex, vertices[0])

		3:
			# Step 3 - make head point at the new vertex
			graph_manager.add_edge(head, vertices[0])
			graph_manager.rm_edge(head, new_vertex)
		4:
			# Step 4 - repositon
			vertices.pop_front()
			new_vertex.move_to(Vector2(vertices[0].position.x - 100, 200))
			reposition_head_tail()
