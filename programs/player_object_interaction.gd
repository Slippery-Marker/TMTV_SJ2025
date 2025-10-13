class_name player_object_interaction
extends RefCounted
var _ray:RayCast3D
var _label:Label
var _objbrain:player_object_interaction
func set_raycast(ray:RayCast3D,label:Label)->void:
	_ray=ray
	_label=label
func _ready()->void:
	_objbrain=player_object_interaction.new()
func _process()->void:
	if _ray.is_colliding():
		var targetcoll=_ray.get_collider()
		if targetcoll != null && targetcoll.has_method("interact"):
			_label.show()
			#communicates the interaction
			if Input.is_action_just_pressed("int1"):
				targetcoll.interact()
		else:
			_label.hide()
	else:
		_label.hide()
#gang i might be stupid, i attached the "Object script" to the floor in the test scene and thought this was broken 😭😭😭😭
