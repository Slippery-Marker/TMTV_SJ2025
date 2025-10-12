class_name player_movement
# Does NOT need to be inheriting from the node it's trying to affect. also RefCounted is cool.
extends RefCounted 
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var character: CharacterBody3D 
#var mouse:player_movement_mouseinfluence
func _ready()->void:
	pass
#	mouse=player_movement_mouseinfluence.new()
func set_character_node(node: CharacterBody3D) -> void:
	# PlayerController's self Getter Setter within player_brain.gd
	character = node
# NOTE: making custom functions is always better than using default ones.
func handle_movement(delta: float) -> void:
	# Get the full gravity vector from the CharacterBody3D node
	var gravity: Vector3 = character.get_gravity()
	# Apply gravity only to the Y component of velocity
	if not character.is_on_floor():
		character.velocity.y += gravity.y * delta
	if Input.is_action_just_pressed("jump") and character.is_on_floor():
		character.velocity.y = JUMP_VELOCITY
	var input_dir := Input.get_vector("mleftward", "mrightward", "mforward", "mbackward")
	var direction := (character.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		character.velocity.x = direction.x * SPEED
		character.velocity.z = direction.z * SPEED
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, SPEED)
		character.velocity.z = move_toward(character.velocity.z, 0, SPEED)
	character.move_and_slide()
#the code is built for pc only using the template provided by godot and tweeked here and there with the help of google gemini (tweak only (base code is human written)) for modular programming (OOP)
