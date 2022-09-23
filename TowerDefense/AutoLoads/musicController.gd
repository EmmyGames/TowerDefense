extends Node

export var menu_music : AudioStream
export var game_music : AudioStream


func play_music(var new_music, var volume):
	if $Music.stream != new_music:
		$Music.stream = new_music
		$Music.volume_db = volume
		$Music.play()
