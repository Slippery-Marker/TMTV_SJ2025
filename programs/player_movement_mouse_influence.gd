class_name player_movement_mouse_influence
extends Node3D
#self explainatory Node Variables
var _camera:Node3D
var _player:CharacterBody3D
#math variables
var _rotation:float=0.0
var _tilt:float=0.0
var _rotation_limit_up:float
var _rotation_limit_down:float
var _mouse_sensitivity:float
var _mouse_rotation:Vector3
var _player_rotation:Vector3
var _camera_rotation:Vector3
#Address to Node Setter
func set_camera_player_node(node:Node3D,node2:CharacterBody3D):
	_camera=node
	_player=node2
#Limit Setter
func set_rotation_limit(limup:float,limdown:float):
	_rotation_limit_up=limup
	_rotation_limit_down=limdown
#Sensitivity Setter
func  set_mouse_sensitivity(sens:float):
	_mouse_sensitivity=sens
#Logic
func mouse_update(event:InputEvent):
	var _mouse:InputEvent=event as InputEventMouseMotion
	_rotation=_mouse.relative.x*_mouse_sensitivity
	_tilt=_mouse.relative.y*_mouse_sensitivity
func update_camera():
	_mouse_rotation.x-=_tilt
	_mouse_rotation.x=clamp(_mouse_rotation.x,_rotation_limit_down,_rotation_limit_up)
	_mouse_rotation.y-=_rotation
	_player_rotation=Vector3(0,_mouse_rotation.y,0)
	_camera_rotation=Vector3(_mouse_rotation.x,0,0)
	_camera.transform.basis=Basis.from_euler(_camera_rotation)
	_player.basis=Basis.from_euler(_player_rotation)
	_camera.rotation.z=0
	_rotation=0
	_tilt=0
func mouse_toggle():
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
#NOTE: this one code nearly had me punch something, following the tutorials is one thing, understanding the code and turning it into a modular logic like this one is another. for context go and watch StayAtHomeDev's tutorial on FPS controller, i followed that and i had to tweak the code a little bit too much, my brain hurts. thanks google gemini.
