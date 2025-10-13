class_name player_movement_mouse_influence
#extends Node3D
extends RefCounted
var _camera:Node3D
var _player:CharacterBody3D
func set_camera_player_node(node:Node3D,node2:CharacterBody3D):
	_camera=node
	_player=node2
func _ready()->void:
	pass
func _physics_process(delta:float)->void:
	pass
