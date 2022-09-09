extends Node


func _ready() -> void:
	connect("pressed", self, "button_pressed")
	connect("mouse_entered", self, "button_hover")
	

func button_pressed():
	Global.emit_signal("button_event", 0)
	match name:
		"MainMenu":
			get_node("../../").queue_free()
			# Make sure the game doesn't switch scenes while paused.
			Global.emit_signal("set_pause", false)
			get_tree().change_scene("res://TowerDefense/_Scenes/MainMenu.tscn")
		"Settings":
			get_tree().change_scene("res://TowerDefense/_Scenes/Settings.tscn")
		"LevelSelect":
			get_tree().change_scene("res://TowerDefense/_Scenes/LevelSelect.tscn")
		"Retry":
			get_tree().reload_current_scene()
			get_node("../../").queue_free()
		"Quit":
			get_tree().quit()
		"Level_01":
			get_tree().change_scene("res://TowerDefense/_Scenes/Level_01.tscn")
		"Resume":
			Global.emit_signal("set_pause", false)


func button_hover() -> void:
	Global.emit_signal("button_event", 2)
