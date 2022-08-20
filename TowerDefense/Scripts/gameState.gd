extends Node

class_name GameState

export var max_lives: int

enum State {IDLE, STAGING}
var currency: int = 1000
var current_lives: int
var current_state = State.IDLE
var current_wave : int = 0
var valid_placement: bool

onready var coins : Label = get_node("../UI/Coins")
onready var lives_UI : Label = get_node("../UI/Lives")
onready var wave_UI : Label = get_node("../UI/WaveNumber")


func _ready() -> void:
	coins.text = "Coins: " + str(currency)
	current_lives = max_lives
	lives_UI.text = "Lives: " + str(current_lives)
	wave_UI.text = "Wave: " + str(current_wave)


func pay_for_tower(var price: int) -> void:
	currency -= price
	coins.text = "Coins: " + str(currency)


func get_currency() -> int:
	return currency


func lose_lives(var damage: int) -> void:
	current_lives -= damage
	if current_lives <= 0:
		current_lives = 0
		get_tree().change_scene("res://TowerDefense/_Scenes/Lose.tscn")
	lives_UI.text = "Lives: " + str(current_lives)


func add_currency(var reward: int) -> void:
	currency += reward
	coins.text = "Coins: " + str(currency)


func set_wave(var new_wave: int) -> void:
	current_wave = new_wave
	wave_UI.text = "Wave: " + str(current_wave)
