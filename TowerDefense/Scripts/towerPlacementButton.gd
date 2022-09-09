extends Button

export (PackedScene) var tower

onready var gs: GameState = get_node("/root/Spatial/GameState")
onready var price_display : Label = get_node("Price")
onready var spatial = get_node("/root/Spatial")


func _ready() -> void:
	connect("pressed", self, "stage_tower")
	connect("mouse_entered", self, "mouse_hover")
	price_display.text = "Price: " + str(tower.instance().price)


func stage_tower() -> void:
	if gs.current_state == gs.State.IDLE and gs.get_currency() >= tower.instance().price:
		Global.emit_signal("button_event", 0)
		var new_tower = tower.instance()
		spatial.add_child(new_tower)
		gs.current_state = gs.State.STAGING
	else:
		Global.emit_signal("button_event", 1)


func mouse_hover() -> void:
	Global.emit_signal("button_event", 2)
