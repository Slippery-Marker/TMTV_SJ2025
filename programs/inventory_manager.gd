class_name inventory_manager
extends RefCounted
var _tape:int=0
var _key:int=0
var _tape_sum:int=0
var _key_sum:int=0
func collect_tape():
	_tape=_tape+1
	_tape_sum+=1
func collect_key():
	_key=_key+1
	_key_sum+=1
func get_tape():
	return _tape
func get_key():
	return _key
func use_tape():
	_tape=_tape-1
func use_key():
	_key=_key-1
func total_tape():
	return _tape_sum
func total_key():
	return _key_sum
