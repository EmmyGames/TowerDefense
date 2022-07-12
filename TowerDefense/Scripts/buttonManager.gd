extends Button
export (PackedScene) var tower

onready var spatial = get_node("/root/Spatial")
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "stage_tower")


func stage_tower() -> void:
	print("Stage Tower")
	var new_tower = tower.instance()
	spatial.add_child(new_tower)
