class_name knoten_klasse extends Area2D

# Static variables and functions
static var node_count: int = 0
static var lerp_speed: int = 15;
static var hover_allowed: bool = true
	
# Sprites
enum sprites {unselected, selected, hovered, current, besucht}
@export var sprite_unselected: CompressedTexture2D
@export var sprite_selected: CompressedTexture2D
@export var sprite_hovered: CompressedTexture2D
@export var sprite_current: CompressedTexture2D
@export var sprite_besucht: CompressedTexture2D

# Node specific data
var id_: int
var label: Label
var sprite: Sprite2D
var move: bool = false
var besucht: bool = false

# Should be removed in future, because a node should not need to know about the controller!
var controller: Node

func _ready():
	controller = get_node("/root")
	
	# Set id and update node_count
	id_ = node_count
	node_count += 1
	# Init visuals
	sprite = get_node("Sprite2D")
	sprite.texture = sprite_unselected
	label = get_node("./Label")
	label.set_text(str(id_))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Make sure the node never collides with the UI 
	var screen_size = get_viewport().get_size()
	if global_position.y < constants.upper_ui_margin:
		global_position = lerp(global_position, Vector2(global_position.x, 100), lerp_speed * delta)
		
	if global_position.y > screen_size.y - constants.lower_ui_margin:
		global_position = lerp(global_position, Vector2(global_position.x, screen_size.y - constants.lower_ui_margin), lerp_speed * delta)
		
	if global_position.x < constants.left_ui_margin:
		global_position = lerp(global_position, Vector2(constants.left_ui_margin, global_position.y), lerp_speed * delta)
		
	if global_position.x > screen_size.x - constants.right_ui_margin:
		global_position = lerp(global_position, Vector2(screen_size.x - constants.right_ui_margin, global_position.y), lerp_speed * delta)
		
	# Make sure every node desnt collide with any other node
	for knoten in get_tree().get_nodes_in_group("vertex_group"):
		if knoten != self && global_position.distance_to(knoten.global_position) <  constants.node_margin:
			knoten.global_position = lerp(knoten.global_position, global_position + (knoten.global_position - global_position).normalized() *  constants.node_margin, lerp_speed * delta)
	
	if move:
		global_position = lerp(global_position, get_global_mouse_position(), lerp_speed * delta)

func set_move(state: bool):
	if state:
		modulate = constants.hovered
	else:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
	move = state

func reset_besucht():
	besucht = false
	
func set_sprite(selection: sprites):
	match selection:
		sprites.unselected: 
			sprite.texture = sprite_unselected
		sprites.selected:
			sprite.texture = sprite_selected
		sprites.hovered:
			sprite.texture = sprite_hovered
		sprites.current:
			sprite.texture = sprite_current
		sprites.besucht:
			sprite.texture = sprite_besucht

func _on_mouse_entered():
	modulate = constants.hovered

func _on_mouse_exited():
	if not move:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
