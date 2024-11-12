class_name SidePanel extends Control


@export var cont_pseu: MarginContainer
@export var cont_var: MarginContainer
@export var cont_call: MarginContainer
@export var cont_exp: MarginContainer
func select_containers(p: bool, v: bool, c: bool, e: bool):
	cont_pseu.visible = bool(p)
	cont_var.visible = bool(v)
	cont_call.visible = bool(c)
	cont_exp.visible = bool(e)

func override_exp(text_: String):
	cont_exp.get_child(0).get_child(3).text = text_
