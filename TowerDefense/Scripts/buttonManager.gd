extends Button
export (PackedScene) var tower

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", self, "stage_tower")


func stage_tower() -> void:
	print("Stage Tower")
	var new_tower = tower.instance()
	add_child(new_tower)
