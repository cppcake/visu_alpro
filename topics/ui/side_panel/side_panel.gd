class_name SidePanel extends Control

@export var button_toggle: Button
func toggle():
	button_toggle.toggle_()
func open():
	button_toggle.open_()
func close():
	button_toggle.close_()

@export var cont_code: CodeContainer
@export var cont_var: VarContainer
@export var cont_call: CallStackContainer
@export var cont_exp: ExpContainer
func select_containers(c: bool, v: bool, cs: bool, i: bool):
	cont_code.visible = bool(c)
	cont_var.visible = bool(v)
	cont_call.visible = bool(cs)
	cont_exp.visible = bool(i)

func override_exp(text_: String):
	cont_exp.override(text_)

func override_code(text_: String):
	cont_code.override(text_)

func override_code_return(text_: String = "Algorithm returned"):
	cont_code.set_return(text_)

func override_code_call(text_: String):
	cont_code.set_call(text_)

func highlight_code(lines: Array):
	cont_code.highlight_lines(lines)

func create_variable() -> Label:
	return cont_var.create_variable()

func reset(c: bool = 1, v: bool = 1, cs: bool = 1, i: bool = 1):
	if c:
		cont_code.reset()
	if v:
		cont_var.reset()
	if cs:
		cont_call.reset()
	if i:
		cont_exp.reset()
