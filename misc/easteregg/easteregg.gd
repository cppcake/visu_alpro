#
# THERE IS NOTHING TO SEE HERE BUT BAD UNDOCUMANTED CODE THAT DOES ABSOLUTLY NOTHING
# 
# HONESTLY JUST GO AWAY THIS CODE DOES NOTHING IMPORTANT I COULD AS WELL DELETE IT
#
# TOTALY USELESSS
#
# LOOK AWAY
#
# NOTING TO SEE
#
# OPEN SOURCE SUCKS SOMETIMES
#
#
# THERE IS NOTHING TO SEE HERE BUT BAD UNDOCUMANTED CODE THAT DOES ABSOLUTLY NOTHING
# 
# HONESTLY JUST GO AWAY THIS CODE DOES NOTHING IMPORTANT I COULD AS WELL DELETE IT
#
# TOTALY USELESSS
#
# LOOK AWAY
#
# NOTING TO SEE
#
# OPEN SOURCE SUCKS SOMETIMES
#
#
# THERE IS NOTHING TO SEE HERE BUT BAD UNDOCUMANTED CODE THAT DOES ABSOLUTLY NOTHING
# 
# HONESTLY JUST GO AWAY THIS CODE DOES NOTHING IMPORTANT I COULD AS WELL DELETE IT
#
# TOTALY USELESSS
#
# LOOK AWAY
#
# NOTING TO SEE
#
# OPEN SOURCE SUCKS SOMETIMES
#
#
# THERE IS NOTHING TO SEE HERE BUT BAD UNDOCUMANTED CODE THAT DOES ABSOLUTLY NOTHING
# 
# HONESTLY JUST GO AWAY THIS CODE DOES NOTHING IMPORTANT I COULD AS WELL DELETE IT
#
# TOTALY USELESSS
#
# LOOK AWAY
#
# NOTING TO SEE
#
# OPEN SOURCE SUCKS SOMETIMES
#
#
# THERE IS NOTHING TO SEE HERE BUT BAD UNDOCUMANTED CODE THAT DOES ABSOLUTLY NOTHING
# 
# HONESTLY JUST GO AWAY THIS CODE DOES NOTHING IMPORTANT I COULD AS WELL DELETE IT
#
# TOTALY USELESSS
#
# LOOK AWAY
#
# NOTING TO SEE
#
# OPEN SOURCE SUCKS SOMETIMES
#
#
# THERE IS NOTHING TO SEE HERE BUT BAD UNDOCUMANTED CODE THAT DOES ABSOLUTLY NOTHING
# 
# HONESTLY JUST GO AWAY THIS CODE DOES NOTHING IMPORTANT I COULD AS WELL DELETE IT
#
# TOTALY USELESSS
#
# LOOK AWAY
#
# NOTING TO SEE
#
# OPEN SOURCE SUCKS SOMETIMES
#

extends Node

@onready var stack_frame_scene = preload("res://topics/ui/scenes/stack_frame.tscn")

var states: Array = []
var current_step: int = 0
var vertices_info: Array = []

enum easteregg_keys
{
	sound,
	current_vertex,
	vertices_info,
	lines_to_paint
}

@export var sprites_array: Array[CompressedTexture2D]
@export var audio_wh: AudioStreamWAV
@export var audio_fc: AudioStreamWAV
@export var audio_ac: AudioStreamWAV
@export var audio_gp: AudioStreamMP3
@export var audio_cc: AudioStreamWAV
@export var audio_sc: AudioStreamWAV
@export var audio_ws: AudioStreamMP3
@export var audio_st: AudioStreamWAV
@export var audio_ct: AudioStreamWAV
var random_pick: Array[int]

@export var graph_manager: GraphManager
func init(_start_vertex: vertex_class):
	$own_gui.visible = true
	states.clear()
	vertices_info.clear()
	
	random_pick.clear()
	for id in range(sprites_array.size()):
		random_pick.push_back(id)
	random_pick.shuffle()
	
	portal()
	
	current_step = 0
	update_visuals()
	return states.size()

func portal():
	for id in range(vertex_class.node_count):
		var current_vertex = graph_manager.get_vertex_by_id(id)
		var vertex_info: Array = []
		vertex_info.push_back("looks bad")
		vertex_info.push_back(current_vertex.get_position())
		vertices_info.push_back(vertex_info)
	
	store_state(-1, [0], false)
	
	store_state(-1, [1], false)
	
	store_state(-1, [2], false)
	
	for id in range(vertex_class.node_count):
		vertices_info[id][0] = "looks good"
		store_state(id, [3, 4], true)
		
		var jump = 1500
		var rng = RandomNumberGenerator.new()
		vertices_info[id][1] = vertices_info[id][1] + Vector2(rng.randf_range(-jump, jump), rng.randf_range(-jump, jump))
		store_state(id, [3, 5], false)
		
	store_state(-1, [6], false)
	store_state(-1, [7], false)

func visualize_step(step: int) -> void:
	current_step = step
	update_visuals()

func stop():
	# Deactivate own gui
	$own_gui.visible = false
	$own_gui/HBoxContainer/MarginContainer2/VBoxContainer/label_return.visible = false
	$cake.visible = false
	$no_cake.visible = false
	$portal_gun.visible = false
	$own_gui/HBoxContainer/MarginContainer2/VBoxContainer/ScrollContainer.visible = false

func store_state(current_vertex: int, lines_to_paint: Array, sound: bool):
	# Create the dictionary for the state
	var dict: Dictionary = {}
	
	dict[easteregg_keys.current_vertex] = current_vertex
	dict[easteregg_keys.sound] = sound
	dict[easteregg_keys.vertices_info] = vertices_info.duplicate(true)
	dict[easteregg_keys.lines_to_paint] = lines_to_paint
	
	# Push the new state
	states.push_back(dict)

@export var code_display: RichTextLabel
func update_lines_selected(lines_to_paint: Array):
	code_display.text = tr("HEHE")
	if lines_to_paint[0] != 0:
		for line_nr: int in lines_to_paint:
			code_display.replace_line(line_nr, ("[wave amp=50.0 freq=5.0 connected=1][color=#004e9f]" + code_display.get_line(line_nr) + "[/color][/wave]"))

func update_visuals():	
	var lines_to_paint = states[current_step].get(easteregg_keys.lines_to_paint)
	update_lines_selected(lines_to_paint)
	
	if lines_to_paint[0] == 0:
		$portal_gun.visible = false
	
	if lines_to_paint[0] == 1:	
		$portal_gun.visible = true
		$dj2.play()
	
	if lines_to_paint[0] == 2:
		$own_gui/HBoxContainer/MarginContainer2/VBoxContainer/ScrollContainer.visible = true
	else:
		$own_gui/HBoxContainer/MarginContainer2/VBoxContainer/ScrollContainer.visible = false
	
	if lines_to_paint[0] == 6:
		$cake.visible = true
		$dj.volume_db = 20
		$dj.stream = audio_ct
		$dj.play()
	else:
		$cake.visible = false
		$dj.volume_db = 0
		
	if lines_to_paint[0] == 7:
		$own_gui/HBoxContainer/MarginContainer2/VBoxContainer/label_return.visible = true
		$no_cake.visible = true
	else:
		$own_gui/HBoxContainer/MarginContainer2/VBoxContainer/label_return.visible = false
		$no_cake.visible = false
	
	for vertex: vertex_class in get_tree().get_nodes_in_group("vertex_group"):
		vertex.set_sprite(vertex_class.sprites.unselected)
	get_tree().call_group("vertex_group", "reset_labels")
	
	var current_vi = states[current_step].get(easteregg_keys.vertices_info)
	var last_vi = null
	if current_step > 0:
		last_vi = states[current_step - 1].get(easteregg_keys.vertices_info)
	var next_vi = null
	if current_step < states.size() - 1:
		next_vi = states[current_step + 1].get(easteregg_keys.vertices_info)
		
	for id in range(vertex_class.node_count):
		if current_vi[id][0] != "looks good":
			break
			
		var current_vertex = graph_manager.get_vertex_by_id(id)
		current_vertex.label_id.text = ""
		current_vertex.sprite.texture = sprites_array[random_pick[id % random_pick.size()]]
		
		if states[current_step].get(easteregg_keys.sound):
			match random_pick[id % random_pick.size()]:
				0:
					$dj.stream = audio_wh
					$dj.play()
				1:
					$dj.stream = audio_fc
					$dj.play()
				2:
					$dj.stream = audio_ac
					$dj.play()
				3:
					$dj.stream = audio_gp
					$dj.play()
				4:
					$dj.stream = audio_cc
					$dj.play()
				5:
					$dj.stream = audio_sc
					$dj.play()
				6:
					$dj.stream = audio_ws
					$dj.play()
				7:
					$dj.stream = audio_st
					$dj.play()
					
		if last_vi != null:
			if last_vi[id][1] != current_vi[id][1]:
				current_vertex.position = current_vi[id][1]
				$portal_gun.look_at(current_vi[id][1])
				$dj2.play()
		if next_vi != null:
			if next_vi[id][1] != current_vi[id][1]:
				current_vertex.position = current_vi[id][1]
