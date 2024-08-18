class_name knoten_klasse extends Area2D

# Stores staticaly how many nodes are in the scene
static var node_count: int = 0

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

var controller: Node

func _ready():
	controller = get_node("/root")
	id_ = node_count
	node_count += 1
	
	sprite = get_node("Sprite2D")
	sprite.texture = sprite_unselected
	
	label = get_node("./Label")
	label.set_text(str(id_))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Make sure the node never collides with the UI 
	var screen_size = get_viewport().get_size()
	if global_position.y < constants.upper_ui_margin:
		global_position = lerp(global_position, Vector2(global_position.x, 100), 25 * delta)
		
	if global_position.y > screen_size.y - constants.lower_ui_margin:
		global_position = lerp(global_position, Vector2(global_position.x, screen_size.y - constants.lower_ui_margin), 25 * delta)
		
	if global_position.x < constants.left_ui_margin:
		global_position = lerp(global_position, Vector2(constants.left_ui_margin, global_position.y), 25 * delta)
		
	if global_position.x > screen_size.x - constants.right_ui_margin:
		global_position = lerp(global_position, Vector2(screen_size.x - constants.right_ui_margin, global_position.y), 25 * delta)
		
	# Make sure every node desnt collide with any other node
	for knoten in get_tree().get_nodes_in_group("knoten_menge"):
		if knoten != self && global_position.distance_to(knoten.global_position) <  constants.node_margin:
			knoten.global_position = lerp(knoten.global_position, global_position + (knoten.global_position - global_position).normalized() *  constants.node_margin, 25 * delta)
	
	if move:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)

func set_move(state: bool):
	move = state

func reset_besucht():
	besucht = false
	
func set_sprite(selection: int):
	match selection:
		1: 
			sprite.texture = sprite_unselected
		2:
			sprite.texture = sprite_selected
		3:
			sprite.texture = sprite_hovered
		4:
			sprite.texture = sprite_current
		5:
			sprite.texture = sprite_besucht

func _on_mouse_entered():
	if sprite.texture != sprite_selected && controller.mode != -1:
		set_sprite(3)

func _on_mouse_exited():
	if sprite.texture != sprite_selected && controller.mode != -1:
		set_sprite(1)
