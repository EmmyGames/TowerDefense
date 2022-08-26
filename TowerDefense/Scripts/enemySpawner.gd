extends Spatial

export (Array, PackedScene) var enemies
export var max_wave: int
export var value_multiplier: int
export var wave_duration: float
export var wave_interval: float

enum State {SPAWNING, WAITING, COUNTING, WIN, LOSE}
var current_wave: int = 0
var rng = RandomNumberGenerator.new()
var spawn_interval: float
var spawn_state = State.COUNTING
var spawn_timer: float
var wave: Array
var wave_timer: float = 0
var wave_value: int

onready var enemy_node = get_node("/root/Spatial/Enemies")
onready var gs: GameState = get_node("/root/Spatial/GameState")


func _physics_process(delta) -> void:
	if not gs.still_playing:
		spawn_state = State.LOSE
	match spawn_state:
		State.SPAWNING:
			if spawn_timer <= 0 and wave.size() > 0:
				spawn_enemy()
				spawn_timer = spawn_interval
			elif wave.size() == 0:
				spawn_state = State.WAITING
				spawn_timer = 0
			else:
				spawn_timer -= delta
		State.WAITING:
			if enemy_node.get_child_count() == 0:
				spawn_state = State.COUNTING
				wave_timer = wave_interval
				if current_wave >= max_wave:
					spawn_state = State.WIN
		State.COUNTING:
			wave_timer -= delta
			if wave_timer <= 0:
				spawn_state = State.SPAWNING
				current_wave += 1
				gs.set_wave(current_wave)
				generate_wave()
				spawn_timer = spawn_interval
		State.WIN:
			gs.still_playing = false
			var win_screen = load("res://TowerDefense/_Scenes/Win.tscn").instance()
			get_node("/root").add_child(win_screen)
			queue_free()
		State.LOSE:
			queue_free()
	
		
func spawn_enemy() -> void:
	var enemy = wave.pop_back().instance()
	enemy_node.add_child(enemy)
	enemy.global_transform.origin = global_transform.origin


func generate_wave() -> void:
	wave_value = current_wave * value_multiplier
	generate_enemies()
	spawn_interval = wave_duration / wave.size()
	

func generate_enemies() -> void:
	wave.clear()
	while wave_value >= 1:
		rng.randomize()
		var random_num = rng.randi_range(0, enemies.size() - 1)
		var enemy = enemies[random_num].instance()
		enemy_node.add_child(enemy)
		if enemy.spawn_cost <= wave_value:
			wave.append(enemies[random_num])
			wave_value -= enemy.spawn_cost
		enemy.free()
