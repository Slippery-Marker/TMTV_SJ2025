class_name object_brain
extends Node3D
enum behaviour{collectible=0,recipient=1,animator=2,destroyable=3}
@export var behavior:behaviour=behaviour.destroyable
func interact() -> void:
	# Logic is now based on the new 'behavior' enum
	match behavior:
		0:
			print("Running COLLECTIBLE interaction logic.")
		1:
			print("Running RECIPIENT interaction logic.")
		2:
			print("Running ANIMATOR interaction logic.")
		3:
			print("Running DESTROYABLE interaction logic.")
			queue_free()
func get_behavior():
	return behavior
