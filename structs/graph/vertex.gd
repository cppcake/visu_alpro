class_name vertex_class extends Area2D

# Static variables and functions
static var node_count: int = 0
static var lerp_speed: int = 15;
static var automatic_labeling = true
static var bahn: bool = true

# Sprites
enum sprites {unselected, selected, hovered, current, visited}
@export var sprite_unselected: CompressedTexture2D
@export var sprite_selected: CompressedTexture2D
@export var sprite_current: CompressedTexture2D
@export var sprite_visited: CompressedTexture2D

# Vertex data
var id_: int
var follow_mouse: bool = false
var visited: bool = false

# Visuals of vertex 
var label_id: Label
var label_info: Label
var label_meta: Label
var sprite: Sprite2D

# Animation
var dest_pos

func _ready():
	# Set id and update node_count
	id_ = node_count
	node_count += 1
	# Init visuals
	sprite = get_node("Sprite2D")
	sprite.texture = sprite_unselected
	
	label_id = get_node("./Label_id")
	label_info = get_node("./Label_info")
	label_meta = get_node("./Label_meta")
	reset_labels()

	dest_pos = null
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if bahn:
		# Make sure every vertex desnt collide with any other vertex
		for vertex in get_tree().get_nodes_in_group("vertex_group"):
			if vertex != self && global_position.distance_to(vertex.global_position) <  constants.node_margin:
				vertex.global_position = lerp(vertex.global_position, global_position + (vertex.global_position - global_position).normalized() *  constants.node_margin, lerp_speed * delta)
		
	# Lerp vertex position to mouse position if vertex is allowed to move
	if follow_mouse:
		global_position = lerp(global_position, get_global_mouse_position(), lerp_speed * delta)
	
	# Lerp vertex position to mouse position if vertex is allowed to move
	if follow_mouse:
		dest_pos = get_global_mouse_position()
	
	if dest_pos != null:
		global_position = lerp(global_position, dest_pos, lerp_speed * delta)

func move_to(dest_pos_: Vector2):
	if dest_pos != null:
		global_position = dest_pos
	dest_pos = dest_pos_
	
func set_follow_mouse(state: bool):
	if state:
		modulate = constants.hovered
	else:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
	follow_mouse = state

func mark_visited():
	set_sprite(vertex_class.sprites.visited)
	label_info.set_text(tr("VISITED"))

func reset_visited():
	visited = false

func reset_labels():
	label_info.text = ""
	label_meta.text = ""
	label_id.text = ""
	if automatic_labeling:
		label_id.text = str(id_)

func set_sprite(selection: sprites):
	match selection:
		sprites.unselected: 
			sprite.texture = sprite_unselected
		sprites.selected:
			sprite.texture = sprite_selected
		sprites.current:
			sprite.texture = sprite_current
		sprites.visited:
			sprite.texture = sprite_visited

func _on_mouse_entered():
	modulate = constants.hovered

func _on_mouse_exited():
	if not follow_mouse:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
