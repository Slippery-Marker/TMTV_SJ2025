class_name player_brain
extends CharacterBody3D
var movement: player_movement
func _ready() -> void:
	movement = player_movement.new()
	movement.set_character_node(self)
func _physics_process(delta: float) -> void:
	movement.handle_movement(delta) 
# NOTE: NEVER USE _process for anything realtime like movement. harsh lesson learned.
func _process(delta: float) -> void:
	pass
