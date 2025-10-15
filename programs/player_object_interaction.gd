class_name player_object_interaction
extends RefCounted
var _ray: RayCast3D
var _label: Label
var _tapelabel:Label
var _keylabel:Label
const BEH = object_brain.behaviour
func set_raycast(ray:RayCast3D, interactlabel:Label,tapelabel:Label,keylabel:Label) -> void:
	_ray = ray
	_label = interactlabel
	_tapelabel=tapelabel
	_keylabel=keylabel
#NOTE: there are times you need to get the parent (ex: glTf import)
func get_node_parent(node: Node) -> Node:
	if not is_instance_valid(node):
		return null
	# 1. Check if the current node has the method we care about
	if node.has_method("interact"):
		return node
	# 2. Try climbing up to the parent.
	var parent = node.get_parent()
	if parent:
		# 3. Recursively check the parent.
		return get_node_parent(parent)
	# 4. If we reach the scene root (no more parent), return null.
	return null
func _process() -> void: 
	if _ray.is_colliding():
		var collider: Node = _ray.get_collider()
		var interactive_object: Node = get_node_parent(collider)
		#NOTE: always check if that shit valid bro i swear to god (crashed almost 100 times)
		#NOTE: if you want one of the behaviors to skip this check, you have to define the enum in a constant variable (this one confused me too long)
		if interactive_object and is_instance_valid(interactive_object) && interactive_object.get_behavior() != BEH.nonekey && interactive_object.get_behavior() !=BEH.tv_but_no_tape && interactive_object.get_behavior() !=BEH.lock_but_no_key:
			_label.show()
			# Communicates the interaction
			if Input.is_action_just_pressed("int1"):
				# Safety check for method before calling
				if interactive_object.has_method("interact"):
					interactive_object.interact()
		else:
			# Object not found, or it was just queue_free()'d
			_label.hide()
			
		if interactive_object and is_instance_valid(interactive_object) && interactive_object.get_behavior() ==BEH.tv_but_no_tape && interactive_object.get_behavior():
			_tapelabel.show()
		else:
			_tapelabel.hide()
		if interactive_object and is_instance_valid(interactive_object) && interactive_object.get_behavior() ==BEH.lock_but_no_key:
			_keylabel.show()
		else:
			_keylabel.hide()
		if interactive_object and is_instance_valid(interactive_object) && interactive_object.get_behavior() == BEH.nonetv:
			_label.hide()
			_tapelabel.hide()
			_keylabel.hide()
	else:
		_label.hide()
		_tapelabel.hide()
		_keylabel.hide()
#gang i might be stupid, i attached the "Object script" to the floor in the test scene and thought this was broken 😭😭😭😭
#also holy fucking shit i fucking hate glTf import, man fuck you the fuck you mean im not allowed to tweak the scene tree?!
#NOTE: the code here is a tweaked version of The Coffee Engineer's Youtube tutorial: How to make 3D interactable items in Godot 4 
