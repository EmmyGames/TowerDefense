extends Button

onready var gs: GameState = get_node("/root/Spatial/GameState")
onready var price_display : Label = get_node("SellPrice")
onready var spatial = get_node("/root/Spatial")


func _ready() -> void:
	connect("pressed", self, "sell_tower")


func sell_tower() -> void:
	gs.add_currency(gs.current_tower.price_invested / 2)
	gs.current_tower.queue_free()
	gs.unset_tower_menu()
