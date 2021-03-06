extends Button
export (PackedScene) var tower

onready var spatial = get_node("/root/Spatial")
onready var gs: GameState = get_node("/root/Spatial/GameState")
onready var price_display : Label = get_node("Label")

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "stage_tower")
	price_display.text = "Price: " + str(tower.instance().price)


func stage_tower() -> void:
	if gs.current_state == gs.State.IDLE && gs.get_currency() >= tower.instance().price:
		var new_tower = tower.instance()
		spatial.add_child(new_tower)
		gs.current_state = gs.State.STAGING
