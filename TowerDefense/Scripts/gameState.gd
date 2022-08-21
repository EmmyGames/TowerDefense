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

onready var buy_menu : Control = get_node("../UI/BuyMenu")
onready var coins : Label = get_node("../UI/Coins")
onready var lives_UI : Label = get_node("../UI/Lives")

onready var tower_select_menu : Control = get_node("../UI/TowerSelect")
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
	tower_select_menu.get_node("Kills").text = "Kills: " + str(current_tower.kill_count)
	tower_select_menu.get_node("Sell/SellPrice").text = "Price: " + str(current_tower.price_invested / 2)
	tower_select_menu.get_node("Upgrade").update_button_display()
	buy_menu.visible = false
	tower_select_menu.visible = true


func set_tower_kills() -> void:
	if current_tower != null:
		tower_select_menu.get_node("Kills").text = "Kills: " + str(current_tower.kill_count)


func unset_tower_menu() -> void:
	if current_tower != null:
		current_tower.is_menu_up = false
		current_tower = null
		buy_menu.visible = true
		tower_select_menu.visible = false
