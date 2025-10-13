class_name player_movement_mouse_influence
extends RefCounted
var _camera:Node3D
var _player:CharacterBody3D
func set_camera_player_node(node:Node3D,node2:CharacterBody3D):
	_camera=node
	_player=node2
func update_camera():
	pass
