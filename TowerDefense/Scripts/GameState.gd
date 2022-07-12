extends Node

class_name GameState

# This could probably be a bool but I wanted to make an enum.
enum State {IDLE, STAGING}
var current_state = State.IDLE
var thing: bool
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
