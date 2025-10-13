class_name player_brain
extends CharacterBody3D
var movement: player_movement
var mmouse:player_movement_mouse_influence
# NOTE?: i got modular gdscript files in my directory i'm instancing my code for better performance right now i'm improving my coding skills. i'm a object oriented programming programmer man i'm a performance valuing developer for real.
# NOTE: the _ready function here is just instancing and doing getter setter things for other files to work. even though all the code i've written for the first 2 Instances are something that will always run when the player is active so it might seem pointless at first.
func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	movement = player_movement.new()
	mmouse=player_movement_mouse_influence.new()
	movement.set_character_node(self)
	mmouse.set_camera_player_node(%CameraController,self)
func _physics_process(delta: float) -> void:
	movement.handle_movement(delta)
# NOTE: NEVER USE _process for anything realtime like movement. harsh lesson learned.
func _process(delta: float) -> void:
	pass
# NOTE: if you have a modular code that needs to run ONLY when _input(event) is called, you cannot call the _input function from the other file in your main file, instead code your logic in a normal ass func and then call it here with a if, this is my rookie advice. god this modulization is killing me (i did this to myself).
func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
#NOTE: i will clean this up later (logic needs to be in seperate file)
	#NOTE: Mouse capture Toggle (middle mouse OR tab key)
	if event.is_action_pressed("act3"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#NOTE: when to move camera (if mouse capture == true and if mouse moving)
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if InputEventMouseMotion:
			mmouse.update_camera()
