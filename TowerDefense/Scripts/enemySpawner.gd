extends Spatial

export (Array, PackedScene) var enemies

onready var enemy_node = get_node("/root/Spatial/Enemies")
var spawning_timer:Timer

func _ready():
	spawning_timer = Timer.new()
	add_child(spawning_timer)
	spawning_timer.wait_time = 4
	spawning_timer.connect("timeout", self, "instantiate_enemy")
	spawning_timer.start()


func instantiate_enemy():
	var enemy = enemies[0].instance()
	enemy_node.add_child(enemy)
	enemy.global_transform.origin = global_transform.origin


