extends Spatial

export (Array, PackedScene) var enemies
export var spawn_interval: float
var spawning_timer:Timer
var rng = RandomNumberGenerator.new()

onready var enemy_node = get_node("/root/Spatial/Enemies")


func _ready():
	spawning_timer = Timer.new()
	add_child(spawning_timer)
	spawning_timer.wait_time = spawn_interval
	spawning_timer.connect("timeout", self, "instantiate_enemy")
	spawning_timer.start()


func instantiate_enemy():
	rng.randomize()
	var random_num = rng.randi_range(0, enemies.size()-1)
	var enemy = enemies[random_num].instance()
	enemy_node.add_child(enemy)
	enemy.global_transform.origin = global_transform.origin
