class_name HashKeyPair
extends Node

var hash
var key: String

func _init(hash_, key_: String):
	hash = hash_
	key = key_

func _to_string():
	return "(%s, %s)" % [hash, key]
