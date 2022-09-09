extends AudioStreamPlayer3D

export (Array, AudioStream) var sound_effects

var rng = RandomNumberGenerator.new()
var last_pitch : float = 1.0
var destroy: bool = false

func _start() -> void:
	set_process(false)
	

func _process(_delta) -> void:
	if destroy and not playing:
		queue_free()


func play_sound(var index) -> void:
	stream = sound_effects[index]
	play()


func play_random_sound(var start_index : int, var end_index : int, var has_random_pitch : bool) -> void:
	rng.randomize()
	var random_index = rng.randi_range(start_index, end_index)
	if has_random_pitch:
		pitch_scale = adjust_pitch()
	else:
		pitch_scale = 1.0
		last_pitch = 1.0
	stream = sound_effects[random_index]
	play()


func adjust_pitch() -> float:
	rng.randomize()
	var random_pitch = rng.randf_range(0.5, 1.5)
	while abs(random_pitch - last_pitch) < 0.1:
		rng.randomize()
		random_pitch = rng.randf_range(0.8, 1.2)
		
	last_pitch = random_pitch
	return random_pitch


func destroy_after_sound(var start_index : int, var end_index : int, var has_random_pitch : bool) -> void:
	play_random_sound(start_index, end_index, has_random_pitch)
	set_process(true)
	destroy = true
