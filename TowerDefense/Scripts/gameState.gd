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
var still_playing: bool = true

onready var buy_menu : Control = get_node("../UI/Info/BuyMenu")
onready var coins : Label = get_node("../UI/Info/Coins")
onready var lives_UI : Label = get_node("../UI/Info/Lives")
onready var tower_select_menu : Control = get_node("../UI/Info/TowerSelect")
onready var wave_UI : Label = get_node("../UI/Info/WaveNumber")


func _ready() -> void:
	Global.connect("set_pause", self, "set_pause")
	Global.connect("toggle_pause", self, "toggle_pause")
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
	if current_lives <= 0 and still_playing:
		var lose_screen = load("res://TowerDefense/_Scenes/Lose.tscn").instance()
		get_node("/root").add_child(lose_screen)
		still_playing = false
	lives_UI.text = "Lives: " + str(current_lives)


func pay_for_tower(var price: int) -> void:
	currency -= price
	coins.text = "Coins: " + str(currency)


func set_wave(var new_wave: int) -> void:
	current_wave = new_wave
	wave_UI.text = "Wave: " + str(current_wave)


func set_tower_menu(var tower: Tower):
	if current_tower != null:
		current_tower.range_indicator.visible = false
	current_tower = tower
	current_tower.is_menu_up = true
	tower_select_menu.get_node("Kills").text = "Kills: " + str(current_tower.kill_count)
	tower_select_menu.get_node("Sell/SellPrice").text = "Sell: " + str(current_tower.price_invested / 2)
	tower_select_menu.get_node("Upgrade").update_button_display()
	tower_select_menu.get_node("LevelXP").text = "Lvl. " + str(current_tower.level) + "\nExp: " + str(current_tower.exp_current) + " / " + str(current_tower.exp_total)
	if current_tower.range_radius < 75:
		current_tower.range_indicator.width = 2 * current_tower.range_radius
		current_tower.range_indicator.depth = 2 * current_tower.range_radius
	current_tower.range_indicator.material.albedo_color = "#93ff75"
	current_tower.range_indicator.visible = true
	buy_menu.visible = false
	tower_select_menu.visible = true


func set_tower_kills() -> void:
	if current_tower != null:
		tower_select_menu.get_node("Kills").text = "Kills: " + str(current_tower.kill_count)
		tower_select_menu.get_node("LevelXP").text = "Lvl. " + str(current_tower.level) + "\nExp: " + str(current_tower.exp_current) + " / " + str(current_tower.exp_total)


func unset_tower_menu() -> void:
	if current_tower != null:
		current_tower.range_indicator.visible = false
		current_tower.is_menu_up = false
		current_tower = null
		buy_menu.visible = true
		tower_select_menu.visible = false


func toggle_pause() -> void:
	get_tree().paused = not get_tree().paused


func set_pause(var is_paused: bool) -> void:
	get_tree().paused = is_paused
