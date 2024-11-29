class_name Operation

enum opcodes
{
	CREATE_NEW_VERTEX,
	MAKE_SHARED,
	POINT_AT,
	SET_SPRITE,
	SET_TAG,
	SET_POINTER_COLOR,
	HIGHLIGHT_CODE,
	CREATE_VARIABLE,
	OVERWRITE_VARIABLE,
	OVERWRITE_CALL,
	OVERWRITE_RETURN,
	CALL,
	RETURN
}

var opcode: opcodes
var argv: Array

func _init(opcode_, argv_):
	opcode = opcode_
	argv = argv_
