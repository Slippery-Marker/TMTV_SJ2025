class_name object_brain
extends Node3D
enum behaviour{tape=0,tv=1,key=2,lock=3,none=4,unlocked_door=5}
enum animation{door=0,item=1,toggle=2,none=3}
@export var behavior:behaviour=behaviour.tape
@export var _animator:animation=animation.none
@export var _if_it_has_a_lock: Node3D
@export var rotation_speed:float=0.5
@export var bob_height:float=0.1
@export var bob_speed:float=0.5
@export var rng_range_min: int = 0 # New: Min value for random number
@export var rng_range_max: int = 100 # New: Max value for random number
var _rng:int
var _initial_y:float=0
var _static_initial_y:float=0
static var _inv:inventory_manager=inventory_manager.new()
func _generate_random_num(min_val: int, max_val: int) -> int:
	return randi() % (max_val - min_val + 1) + min_val
func _ready() -> void:
	_initial_y = global_transform.origin.y
	_static_initial_y = rotation.y # Initialize target to current X rotation
	if behavior==5:
		if _if_it_has_a_lock && is_instance_valid(_if_it_has_a_lock):
			_if_it_has_a_lock.queue_free()
	randomize()
	_rng=_generate_random_num(rng_range_min,rng_range_max)
func  _set_behavior(BEH:int):
	behavior=BEH
func _set_rng():
	_rng=_generate_random_num(rng_range_min,rng_range_max)
#NOTE: the problem with this ready function is it makes a new one for all of the functions instantiated from the called class, so yeah inventory no worky if put in _ready().
func _process(delta: float) -> void:
	match _animator:
		0:
				queue_free()
		1:
			rotate_y(delta * rotation_speed * TAU)
			var time = Time.get_ticks_usec() / 1000000.0
			var vertical_offset = sin(time * bob_speed * TAU) * bob_height
			var new_position = global_transform.origin
			new_position.y = _initial_y + vertical_offset
			global_transform.origin = new_position
		3:
			# Resets rotation to the value stored in _initial_rotation_y
			rotation = Vector3(rotation.x, _static_initial_y, rotation.z)
			# Resets bobbing position to the initial Y
			var current_position = global_transform.origin
			current_position.y = _initial_y
			global_transform.origin = current_position
func interact() -> void:
	match behavior:
		0:
			print("Running TAPE interaction logic.")
			_inv.collect_tape()
			print("(tapes collected: ",_inv.get_tape(),")")
			queue_free()
		1:
			print("Running TV interaction logic.")
			if _inv.get_tape()!=0:
				_inv.use_tape()
				print("(tapes remaining: ",_inv.get_tape(),")")
				if _rng==21 || _rng== 10 || _rng==81:
					print("WOULD YOU LOOK AT THAT! THE WORLD IS not revolving its the TV!!!")
					_animator=1
				else:
					print("Eh... ",_rng," is not a part of the the secret numbers gang")
					randomize()
					_set_rng()
			else:
				printerr("INSUFFICIENT TAPES!")
				_animator=3
		2:
			print("Running KEY interaction logic.")
			_inv.collect_key()
			print("(keys collected: ",_inv.get_key(),")")
			queue_free()
		3:
			print("Running LOCK interaction logic.")
			if _inv.get_key()!=0:
				_inv.use_key()
				print("(keys remaining: ",_inv.get_key(),")")
				if _if_it_has_a_lock && is_instance_valid(_if_it_has_a_lock):
					_if_it_has_a_lock.queue_free()
				_set_behavior(5)
			else:
				printerr("INSUFFICIENT KEYS!")
		5:
			print("Running DOORUNLOCKED interaction logic.")
			_animator=0
func get_behavior():
	return behavior
#NOTE: this might be one of the most modular things in he project, you put this on any object it will work but yeah its pretty limited but hey im running low on time thanks to what happend with Mono Godot and the outdated documentation/tutorials that just throw errors even when you copy 1 by 1 idk how that's even possible.
