extends Node

class_name GameState

export var max_lives: int

enum State {IDLE, STAGING}
var currency: int = 1000
var current_lives: int
var current_state = State.IDLE
var current_wave : int = 0
var valid_placement: bool
var current_tower: Tower

onready var coins : Label = get_node("../UI/Coins")
onready var kills_UI : Label = get_node("../UI/TowerKills")
onready var lives_UI : Label = get_node("../UI/Lives")
onready var tower_1_UI : Button = get_node("../UI/Tower1")
onready var tower_2_UI : Button = get_node("../UI/Tower2")
onready var tower_3_UI : Button = get_node("../UI/Tower3")
onready var upgrade_tower_UI : Button = get_node("../UI/UpgradeTower")
onready var wave_UI : Label = get_node("../UI/WaveNumber")


func _ready() -> void:
	coins.text = "Coins: " + str(currency)
	current_lives = max_lives
	lives_UI.text = "Lives: " + str(current_lives)
	wave_UI.text = "Wave: " + str(current_wave)


func add_currency(var reward: int) -> void:
	currency += reward
	coins.text = "Coins: " + str(currency)


func get_currency() -> int:
	return currency


func lose_lives(var damage: int) -> void:
	current_lives -= damage
	if current_lives <= 0:
		current_lives = 0
		get_tree().change_scene("res://TowerDefense/_Scenes/Lose.tscn")
	lives_UI.text = "Lives: " + str(current_lives)


func pay_for_tower(var price: int) -> void:
	currency -= price
	coins.text = "Coins: " + str(currency)


func set_wave(var new_wave: int) -> void:
	current_wave = new_wave
	wave_UI.text = "Wave: " + str(current_wave)


func set_tower_menu(var tower: Tower):
	current_tower = tower
	current_tower.is_menu_up = true
	kills_UI.text = "Kills: " + str(current_tower.kill_count)
	tower_1_UI.visible = false
	tower_2_UI.visible = false
	tower_3_UI.visible = false
	upgrade_tower_UI.visible = true
	kills_UI.visible = true


func set_tower_kills() -> void:
	if current_tower != null:
		kills_UI.text = "Kills: " + str(current_tower.kill_count)


func unset_tower_menu() -> void:
	if current_tower != null:
		current_tower.is_menu_up = false
		current_tower = null
		tower_1_UI.visible = true
		tower_2_UI.visible = true
		tower_3_UI.visible = true
		upgrade_tower_UI.visible = false
		kills_UI.visible = false
