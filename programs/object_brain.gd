class_name object_brain
extends Node3D
enum behaviour{tape=0,tv=1,key=2,locked_door=3}
@export var behavior:behaviour=behaviour.tape
static var _inv:inventory_manager=inventory_manager.new()
#func _ready()->void:
#	_inv=inventory_manager.new()
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
			else:
				printerr("INSUFFICIENT TAPES!")
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
func get_behavior():
	return behavior
