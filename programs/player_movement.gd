class_name player_movement
# NOTE: Does NOT need to be inheriting from the node it's trying to affect. also RefCounted is kinda cool.
extends RefCounted 
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var _player: CharacterBody3D 
# PlayerController's self Getter Setter within player_brain.gd
func set_character_node(node: CharacterBody3D) -> void:
	_player = node
# NOTE: making custom functions is always better than using default ones.
func handle_movement(delta: float) -> void:
	# Get the full gravity vector from the CharacterBody3D node
	var gravity: Vector3 = _player.get_gravity()
	# Apply gravity only to the Y component of velocity
	if not _player.is_on_floor():
		_player.velocity.y += gravity.y * delta
	if Input.is_action_just_pressed("jump") and _player.is_on_floor():
		_player.velocity.y = JUMP_VELOCITY
	var input_dir := Input.get_vector("mleftward", "mrightward", "mforward", "mbackward")
	var direction := (_player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		_player.velocity.x = direction.x * SPEED
		_player.velocity.z = direction.z * SPEED
	else:
		_player.velocity.x = move_toward(_player.velocity.x, 0, SPEED)
		_player.velocity.z = move_toward(_player.velocity.z, 0, SPEED)
	_player.move_and_slide()
#NOTE: the code is built for pc only using the template provided by godot and tweeked here and there with the help of google gemini (tweak only (base code is human written)) for modular programming (OOP)
