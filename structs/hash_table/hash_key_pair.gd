class_name HashKeyPair

var hash_value
var key: String

func _init(hash_, key_: String):
	hash_value = hash_
	key = key_

func _to_string():
	return "(%s, %s)" % [hash_value, key]
