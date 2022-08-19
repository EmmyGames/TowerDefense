extends Spatial

export (Array, PackedScene) var enemies
export var value_multiplier: int
export var max_wave: int
export var wave_duration: float
export var wave_interval: float
enum State {SPAWNING, WAITING, COUNTING, WIN, LOSE}
var current_wave: int = 0
var wave_value: int

var spawn_interval: float

var wave: Array

var spawn_timer: float
var wave_timer: float = 0
var rng = RandomNumberGenerator.new()
var spawn_state = State.COUNTING


onready var enemy_node = get_node("/root/Spatial/Enemies")


func _physics_process(delta):
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
				generate_wave()
				spawn_timer = spawn_interval
		State.WIN:
			print("You won!")
#	if spawn_state == State.SPAWNING:
#		if spawn_timer <= 0 and wave.size() > 0:
#			spawn_enemy()
#		elif wave.size() == 0:
#			spawn_state = State.WAITING
#			spawn_timer = 0
#		else:
#			spawn_timer -= delta
#	if spawn_state == State.WAITING:
#		if enemy_node.get_child_count() == 0:
#			spawn_state = State.COUNTING
#			wave_timer = wave_interval
#	if spawn_state == State.COUNTING:
#		wave_timer -= delta
#		if wave_timer <= 0:
#			spawn_state = State.SPAWNING
#			current_wave += 1
#			generate_wave()
#			spawn_timer = spawn_interval
		
		
func spawn_enemy():
	var enemy = wave.pop_back().instance()
	enemy_node.add_child(enemy)
	enemy.global_transform.origin = global_transform.origin


func generate_wave():
	wave_value = current_wave * value_multiplier
	generate_enemies()
	spawn_interval = wave_duration / wave.size()
	

func generate_enemies():
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
	print(wave)
