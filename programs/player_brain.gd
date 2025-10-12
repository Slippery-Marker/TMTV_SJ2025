class_name player_brain
extends CharacterBody3D
var movement: player_movement
#var mmouse:player_movement_mouseinfluence
#i got modular gdscript files in my directory i'm instancing my code for better performance right now i'm improving my coding skills. i'm a object oriented programming programmer man i'm a performance valuing developer for real.
#anyways yeah the _ready function here is just instancing and doing getter setter things for other files to work. even though all the code i've written for the first 2 Instances are something that will always run when the player is active so it might seem pointless at first.
func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	movement = player_movement.new()
	movement.set_character_node(self)
#	mmouse=player_movement_mouseinfluence.new()
#	mmouse.set_camera_node(%CameraController,self)
func _physics_process(delta: float) -> void:
	movement.handle_movement(delta)
# NOTE: NEVER USE _process for anything realtime like movement. harsh lesson learned.
func _process(delta: float) -> void:
	pass
func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
	if event.is_action_pressed("act2"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
