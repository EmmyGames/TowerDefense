extends Node

onready var pause_menu = $PauseMenu


func _ready() -> void:
	Global.connect("toggle_pause", self, "toggle_pause_menu")
	Global.connect("set_pause", self, "set_pause_menu")


func set_pause_menu(var is_paused: bool) -> void:
	pause_menu.visible = is_paused


func toggle_pause_menu() -> void:
	pause_menu.visible = not pause_menu.is_visible()
