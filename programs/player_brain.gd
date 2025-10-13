class_name player_brain
extends CharacterBody3D
var movement: player_movement
var mmouse:player_movement_mouse_influence
#NOTE: Changable Settings
@export var camera_rotation_up:=deg_to_rad(+85)
@export var camera_rotation_down:=deg_to_rad(-85)
@export var mouse_sensitivity:float=(1)
func _ready() -> void:
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	movement = player_movement.new()
	mmouse=player_movement_mouse_influence.new()
	movement.set_character_node(self)
	mmouse.set_camera_player_node(%CameraController,self)
	mmouse.set_rotation_limit(camera_rotation_up,camera_rotation_down)
	mmouse.set_mouse_sensitivity(mouse_sensitivity)
func _process(delta: float) -> void:
		mmouse.update_camera(delta)
func _physics_process(delta: float) -> void:
	movement.handle_movement(delta)
func _input(event):
	#NOTE: Closes game with ESC.
	if event.is_action_pressed("exit"):
		get_tree().quit()
#NOTE: i will clean this up later (logic needs to be in seperate file)
	#NOTE: Mouse capture Toggle (middle mouse OR tab key OR even L key)
	if event.is_action_pressed("act3"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED && event is InputEventMouseMotion:
		mmouse.mouse_update(event)
# NOTE?: i got modular gdscript files in my directory i'm instancing my code for better performance right now i'm improving my coding skills. i'm a object oriented programming programmer man i'm a performance valuing developer for real.
# NOTE: the _ready function here is just instancing and doing getter setter things for other files to work. even though all the code i've written for the first 2 Instances are something that will always run when the player is active so it might seem pointless at first.
# NOTE: NEVER USE _process for anything realtime like movement. harsh lesson learned.
# NOTE: if you have a modular code that needs to run ONLY when _input(event) is called, you cannot call the _input function from the other file in your main file, instead code your logic in a normal ass func and then call it here with a if, this is my rookie advice. god this modulization is killing me (i did this to myself).
