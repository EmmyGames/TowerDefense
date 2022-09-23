extends Node

export var level_music : AudioStream
export var volume_db : float = -15

func _ready():
	AudioManager.play_music(level_music, volume_db)
