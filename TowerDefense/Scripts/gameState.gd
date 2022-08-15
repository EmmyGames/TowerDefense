extends Node

class_name GameState

export var max_lives: int

# This could probably be a bool but I wanted to make an enum.
enum State {IDLE, STAGING}
var current_state = State.IDLE
var valid_placement: bool
var currency: int = 1000
var current_lives: int

onready var coins : Label = get_node("../UI/Coins")
onready var lives_UI : Label = get_node("../UI/Lives")


func _ready() -> void:
	coins.text = "Coins: " + str(currency)
	current_lives = max_lives
	lives_UI.text = "Lives: " + str(current_lives)
	
func pay_for_tower(var price: int) -> void:
	currency -= price
	coins.text = "Coins: " + str(currency)

func get_currency() -> int:
	return currency


func lose_lives(var damage: int) -> void:
	current_lives -= damage
	if current_lives <= 0:
		current_lives = 0
		# TODO: Go to loss screen
	lives_UI.text = "Lives: " + str(current_lives)


func add_currency(var reward: int) -> void:
	currency += reward
	coins.text = "Coins: " + str(currency)
