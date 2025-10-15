class_name object_brain
extends Node3D
enum behaviour{tape=0,tv=1,key=2,lock=3,nonekey=4,unlocked_door=5,tv_but_no_tape=6,lock_but_no_key=7,video_cycler=8,nonetv=9}
enum animation{door=0,item=1,toggle=2,rest=3,none=4}
static var _shared_tape_video_pool:Array[VideoStream]
static var _shared_tape_audio_pool:Array[AudioStream]
static var _is_pool_initialized: bool = false
static var _tape_rng_poolsize:int
static var _tape_rng_poolpointer:int
static var _tape_rng:int
@export var video_streams_tape: Array[VideoStream]
@export var audio_streams_tape: Array[AudioStream]
@export var normal_audio:Array[AudioStream]
@export var behavior:behaviour=behaviour.tape
@export var _animator:animation=animation.none
@export var _if_it_has_a_lock: Node3D
@export var rotation_speed:float=0.5
@export var bob_height:float=0.1
@export var bob_speed:float=0.5
@export var rng_range_min: int = 0 # New: Min value for random number
@export var rng_range_max: int = 100 # New: Max value for random number
var _video_player:VideoStreamPlayer
var _audio_player:AudioStreamPlayer3D
var _door_audio_player:AudioStreamPlayer3D
var _rng:int
var _initial_y:float=0
var _static_initial_y:float=0
var _holder
static var _inv:inventory_manager=inventory_manager.new()
func _ready() -> void:
	_initial_y = global_transform.origin.y
	_static_initial_y = rotation.y # Initialize target to current X rotation
	randomize()
	match behavior:
		0:
			pass
		1:
			if !_is_pool_initialized:
				_shared_tape_video_pool.assign(video_streams_tape)
				_shared_tape_audio_pool.assign(audio_streams_tape)
				_is_pool_initialized = true
			_tape_rng_poolsize=_shared_tape_video_pool.size()
			_set_rng_tv()
			if %TvStreamer && %TvAudioStreamer:
				_holder=%holder
				_holder.hide()
				_video_player=%TvStreamer
				_audio_player=%TvAudioStreamer
				_video_player.finished.connect(_on_video_finished)
				print("Array Size? ",_tape_rng_poolsize," running in ready")
		3:
			if %DoorAudioStreamer:
				_door_audio_player=%DoorAudioStreamer
		5:
			if %DoorAudioStreamer:
				_door_audio_player=%DoorAudioStreamer
			if _if_it_has_a_lock && is_instance_valid(_if_it_has_a_lock):
				_if_it_has_a_lock.queue_free()
		6:
			if %TvStreamer && %TvAudioStreamer:
				_video_player=%TvStreamer
				_audio_player=%TvAudioStreamer
				_holder=%holder
				_holder.hide()
			if !_is_pool_initialized:
				_shared_tape_video_pool.assign(video_streams_tape)
				_shared_tape_audio_pool.assign(audio_streams_tape)
				_is_pool_initialized = true
			_tape_rng_poolsize=_shared_tape_video_pool.size()
			_video_player.finished.connect(_on_video_finished)
			print("Array Size? ",_tape_rng_poolsize," running in ready")
			_set_rng_tape()
		7:
			if %DoorAudioStreamer:
				_door_audio_player=%DoorAudioStreamer
		8:
			if %TvStreamer && %TvAudioStreamer:
				_video_player=%TvStreamer
				_audio_player=%TvAudioStreamer
				_holder=%holder
				_holder.hide()
			if !_is_pool_initialized:
				_shared_tape_video_pool.assign(video_streams_tape)
				_shared_tape_audio_pool.assign(audio_streams_tape)
				_is_pool_initialized = true
			_tape_rng_poolsize=_shared_tape_video_pool.size()
			_video_player.finished.connect(_on_video_finished)
			print("Array Size? ",_tape_rng_poolsize," running in ready")
func _on_video_finished():
	_video_player.stop()
	_audio_player.stop()
	_video_player.stream=null
	_audio_player.stream=null
	_holder.hide()
func  _set_behavior(BEH:int):
	@warning_ignore("int_as_enum_without_cast")
	behavior=BEH
func _set_animator(ANI:int):
	@warning_ignore("int_as_enum_without_cast")
	_animator=ANI
func _generate_random_num(min_val: int, max_val: int) -> int:
	return randi() % (max_val - min_val + 1) + min_val
func _gen_rand_num_tape(min_val:int,max_val:int)->int:
	return randi()%(max_val-min_val+1)
func _set_rng_tape():
	_tape_rng_poolsize=_shared_tape_video_pool.size()
	_tape_rng_poolpointer=_tape_rng_poolsize-1
	print("pool size ",_tape_rng_poolsize," beginner pointer ",_tape_rng_poolpointer)
	if _tape_rng_poolsize>0:
		_tape_rng=_gen_rand_num_tape(0,_tape_rng_poolpointer)
		print("current pointer on ",_tape_rng)
	else:
		_tape_rng=0
		printerr("WE ARE OUT OF MEDIA, GO MAKE SOME :(")
func _set_rng_tv():
	_rng=_generate_random_num(rng_range_min,rng_range_max)

#NOTE: the problem with this ready function is it makes a new one for all of the functions instantiated from the called class, so yeah inventory no worky if put in _ready().
func _process(delta: float) -> void:
	match _animator:
		0:
				queue_free()
		1:
			rotate_y(delta * rotation_speed * TAU)
			var time = Time.get_ticks_usec() / 1000000.0
			var vertical_offset = sin(time * bob_speed * TAU) * bob_height
			var new_position = global_transform.origin
			new_position.y = _initial_y + vertical_offset
			global_transform.origin = new_position
		3:
			# Resets rotation to the value stored in _initial_rotation_y
			rotation = Vector3(rotation.x, _static_initial_y, rotation.z)
			# Resets bobbing position to the initial Y
			var current_position = global_transform.origin
			current_position.y = _initial_y
			global_transform.origin = current_position
			_set_animator(4)
		4:
			pass
	match behavior:
		1:
			if _inv.get_tape()==0:
				_set_behavior(6)
		6:
			if _inv.get_tape()>0:
				_set_behavior(1)
		4:
			if _inv.get_key()==0:
				_set_behavior(7)
		7:
			if _inv.get_key()>0:
				_set_behavior(3)
		8:
			_set_behavior(9)
			await _video_player.finished
			_set_behavior(6)
		9:
			pass
func interact():
	match behavior:
		0:
			print("Running TAPE interaction logic.")
			_inv.collect_tape()
			print("(tapes collected: ",_inv.get_tape(),")")
			print("(amount of overall collected tapes: ",_inv.total_tape())
			queue_free()
		1:
			print("Running TV interaction logic.")
			if _inv.get_tape()!=0:
				_set_rng_tape()
				_inv.use_tape()
				print("(tapes remaining: ",_inv.get_tape(),")")
				if _rng==23 || _rng== 10 || _rng==81:
					_set_behavior(9)
					print("WOULD YOU LOOK AT THAT! THE WORLD IS not revolving its the TV!!!",_rng)
					_set_animator(1)
					_audio_player.stream=normal_audio[0]
					_audio_player.play()
					randomize()
					_set_rng_tv()
					await _audio_player.finished
					queue_free()
				elif _tape_rng_poolsize >=1:
					_set_behavior(8)
					print("Eh... ",_rng," is not a part of the the secret numbers gang")
					_holder.show()
					_video_player.stream=_shared_tape_video_pool[_tape_rng]
					_audio_player.stream=_shared_tape_audio_pool[_tape_rng]
					print("Playing: ",_tape_rng)
					_video_player.play()
					_audio_player.play()
					print("items before delete: ",_shared_tape_video_pool)
					if _tape_rng_poolsize==1:
						printerr("LAST FILE, CANNOT DELETE")
						print("items in poolsize check: ",_shared_tape_video_pool)
					else:
						_shared_tape_video_pool.remove_at(_tape_rng)
						_shared_tape_audio_pool.remove_at(_tape_rng)
						_set_rng_tape()
						randomize()
						print("Array Size? ",_tape_rng_poolsize," after delete")
					_set_rng_tv()
			else:
				_set_behavior(6)
		2:
			print("Running KEY interaction logic.")
			_inv.collect_key()
			print("(keys collected: ",_inv.get_key(),")")
			print("(amount of overall collected keys: ",_inv.total_key())
			queue_free()
		3:
			print("Running LOCK interaction logic.")
			if _inv.get_key()!=0:
				_inv.use_key()
				print("(keys remaining: ",_inv.get_key(),")")
				if _if_it_has_a_lock && is_instance_valid(_if_it_has_a_lock):
					_door_audio_player.stream=normal_audio[1]
					_door_audio_player.play()
					_set_behavior(9)
					await _door_audio_player.finished
					_if_it_has_a_lock.queue_free()
				_set_behavior(5)
			else:
				printerr("INSUFFICIENT KEYS!")
		4:
			pass
		5:
			print("Running DOORUNLOCKED interaction logic.")
			_door_audio_player.stream=normal_audio[0]
			_door_audio_player.play()
			_set_behavior(9)
			await _door_audio_player.finished
			_set_animator(0)
func get_behavior():
	return behavior
#NOTE: this might be one of the most modular things in the project, you put this on any object it will work but yeah its pretty limited but hey im running low on time thanks to what happend with Mono Godot and the outdated documentation/tutorials that just throw errors even when you copy 1 by 1 idk how that's even possible.
#NOTE: this particular script was actually fun to make. realizing how to handle the logic in a way that works and throwing the initial solution that was in mind away. it's all about experimenting with logic...and getting help when necessary. i did ask gemini about my errors and how to code in animation but all of it has human input in actual logical writing (gemini can be helpful but lots of the times it would tweak things that would crash the whole game, figured those out on my own)
#NOTE: the video player setup took me long enough, but the person who came in clutch was Rembot Games with their youtube tutorial: Videos on TV Screens in 3D Space (with 3D Audio) | Godot 4.5 Tutorial
#NOTE: planning the structure happened while i was in university taking my "Software Engineering" class, took my mini notebook out and started drawing the flow in a flowchart manner.
