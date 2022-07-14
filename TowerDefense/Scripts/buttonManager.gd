extends Button
export (PackedScene) var tower

onready var spatial = get_node("/root/Spatial")
onready var gs: GameState = get_node("/root/Spatial/GameState")

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "stage_tower")


func stage_tower() -> void:
	if gs.current_state == gs.State.IDLE:
		var new_tower = tower.instance()
		spatial.add_child(new_tower)
		gs.current_state = gs.State.STAGING
