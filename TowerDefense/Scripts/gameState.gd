extends Node

class_name GameState

# This could probably be a bool but I wanted to make an enum.
enum State {IDLE, STAGING}
var current_state = State.IDLE
var valid_placement: bool
var currency: int = 1000
onready var coins : Label = get_node("../UI/Coins")

func _ready():
	coins.text = "Coins: " + str(currency)
	
func pay_for_tower(var price: int):
	currency -= price
	coins.text = "Coins: " + str(currency)

func get_currency() -> int:
	return currency
	
