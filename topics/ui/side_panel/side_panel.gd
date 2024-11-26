class_name SidePanel extends Control

@export var is_open: bool

@export var button_toggle: Button
@export var cont_code: CodeContainer
@export var cont_var: VarContainer
@export var cont_call: CallStackContainer
@export var cont_exp: ExpContainer

# OPEN AND CLOSE STUFF
func _ready():
	button_toggle.open = is_open
	if is_open:
		button_toggle.force_open()
	else:
		button_toggle.force_close()
func _process(_delta):
	is_open = button_toggle.open
func toggle():
	button_toggle.toggle_()
func open():
	button_toggle.open_()
func close():
	button_toggle.close_()

# STUFF FOR ALL CONTAINER
func select_containers(c: bool, v: bool, cs: bool, i: bool):
	cont_code.visible = bool(c)
	cont_var.visible = bool(v)
	cont_call.visible = bool(cs)
	cont_exp.visible = bool(i)
func reset(c: bool = 1, v: bool = 1, cs: bool = 1, i: bool = 1):
	if c:
		cont_code.reset()
	if v:
		cont_var.reset()
	if cs:
		cont_call.reset()
	if i:
		cont_exp.reset()

# INFO CONTAINER STUFF
func override_exp(text_: String):
	cont_exp.override(text_)

# CODE CONTAINER STUFF
func override_code(text_: String, update_init: bool = true):
	cont_code.override(text_, update_init)
func override_code_return(text_: String = "Algorithm returned", color: Color = constants.color_1_c):
	cont_code.set_return(text_, color)

func override_code_call(text_: String):
	cont_code.set_call(text_)
func highlight_code(lines: Array):
	cont_code.highlight_lines(lines)
func highlight_code_undo():
	cont_code.highlight_lines_undo()

# VARIABLE CONTAINER STUFF
func create_variable() -> Label:
	return cont_var.create_variable()
func create_variable_undo():
	cont_var.create_variable_undo()
func overwrite_variable(index: int, text_: String):
	cont_var.overwrite_variable(index, text_)
func overwrite_variable_undo(index: int):
	cont_var.overwrite_variable_undo(index)

# STACKFRAME CONTAINER STUFF
func create_stackframe(stackframe_name: String):
	return cont_call.create_stackframe(stackframe_name)
func create_stackframe_undo():
	return cont_call.create_stackframe_undo()
func remove_stackframe():
	cont_call.remove_stackframe()
func remove_stackframe_undo():
	cont_call.remove_stackframe_undo()
# Needed for legacy reasons
func push_call() -> Label:
	return cont_call.push_call_()
