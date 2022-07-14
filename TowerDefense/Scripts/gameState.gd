extends Node

class_name GameState

# This could probably be a bool but I wanted to make an enum.
enum State {IDLE, STAGING}
var current_state = State.IDLE
var valid_placement: bool
var currency: int = 100
onready var coins : Label = get_node("../ColorRect/Coins")

func _ready():
	coins.text = "Coins: " + str(currency)
