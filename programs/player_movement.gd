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
		#NOTE: thanks to LesusX for his BASED github repo with this one (lerp)
		_player.velocity.x = lerp(_player.velocity.x, direction.x* SPEED,delta*7)
		_player.velocity.z = lerp(_player.velocity.z, direction.z *SPEED,delta*7)
	_player.move_and_slide()
#NOTE: fucked up physics push system that gemini wrote, like why does it work this BAD
	for i in _player.get_slide_collision_count():
		const PUSH_FACTOR = 2000
		var collision = _player.get_slide_collision(i)
	# Check if the collided object is a RigidBody3D
		if collision.get_collider() is RigidBody3D:
			var body: RigidBody3D = collision.get_collider()
			var horizontal_player_vel = Vector3(_player.velocity.x, 0, _player.velocity.z)
			if horizontal_player_vel.length_squared()>0.001:
				var normal = collision.get_normal()
				var speed_into_box = horizontal_player_vel.dot(normal)
				if speed_into_box < 0:
					var push_direction = -normal.normalized()
					var push_magnitude = (-speed_into_box) * body.mass * PUSH_FACTOR
					body.apply_force(push_direction * push_magnitude)
#NOTE: the code is built for pc only using the template provided by godot and tweeked here and there with the help of google gemini (tweak only (base code is human written)) for modular programming (OOP)
