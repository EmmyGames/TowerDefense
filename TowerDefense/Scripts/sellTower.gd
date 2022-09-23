extends Button

onready var gs: GameState = get_node("/root/Spatial/GameState")
onready var price_display : Label = get_node("SellPrice")
onready var spatial = get_node("/root/Spatial")


func _ready() -> void:
	connect("pressed", self, "sell_tower")
	connect("mouse_entered", self, "mouse_hover")


func sell_tower() -> void:
	gs.add_currency(int(gs.current_tower.price_invested / 2.0))
	gs.current_tower.queue_free()
	gs.unset_tower_menu()
	Global.emit_signal("button_event", 0)


func mouse_hover() -> void:
	Global.emit_signal("button_event", 2)
