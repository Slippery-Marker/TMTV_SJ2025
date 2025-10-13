class_name object_brain
extends Node3D
enum behaviour{tape=0,tv=1,key=2,locked_door=3}
enum animation{door=0,item=1,toggle=2,none=3}
@export var behavior:behaviour=behaviour.tape
@export var animator:animation=animation.none
@export var rotation_speed:float=0.5
@export var bob_height:float=0.1
@export var bob_speed:float=0.5
var _initial_y:float=0
var _static_initial_y:float=0
static var _inv:inventory_manager=inventory_manager.new()
#NOTE: the problem with this ready function is it makes a new one for all of the functions instantiated from the called class, so yeah inventory no worky if put in _ready().
func _ready()->void:
	_initial_y=global_transform.origin.y
#	_inv=inventory_manager.new()
func _process(delta: float) -> void:
	match  animator:
		0:
			pass
		1:
			rotate_y(delta * rotation_speed * TAU)
			var time = Time.get_ticks_usec() / 1000000.0
			var vertical_offset = sin(time * bob_speed * TAU) * bob_height
			var new_position = global_transform.origin
			new_position.y = _initial_y + vertical_offset
			global_transform.origin = new_position
func interact() -> void:
	# Logic is now based on the new 'behavior' enum
	match behavior:
		0:
			print("Running TAPE interaction logic.")
			_inv.collect_tape()
			print(_inv.get_tape())
			queue_free()
		1:
			print("Running TV interaction logic.")
			if _inv.get_tape()!=0:
				_inv.use_tape()
				print("(tapes remaining: ",_inv.get_tape(),")")
				animator=1
			else:
				printerr("INSUFFICIENT TAPES!")
				animator=3
				reset_visual_state()
		2:
			print("Running KEY interaction logic.")
			_inv.collect_key()
			queue_free()
		3:
			print("Running DOORLOCKED interaction logic.")
			if _inv.get_key()!=0:
				queue_free()
			else:
				printerr("INSUFFICIENT KEYS!")
func reset_visual_state() -> void:
	# Resets rotation to the value stored in _initial_rotation_y
	rotation = Vector3(rotation.x, _static_initial_y, rotation.z)
	# Resets bobbing position to the initial Y
	var current_position = global_transform.origin
	current_position.y = _initial_y
	global_transform.origin = current_position
func get_behavior():
	return behavior
