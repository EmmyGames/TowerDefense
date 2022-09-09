extends AudioStreamPlayer

export (Array, AudioStream) var sound_effects

func _ready():
	Global.connect("button_event", self, "play_sound")


func play_sound(var index: int) -> void:
	stream = sound_effects[index]
	play()
