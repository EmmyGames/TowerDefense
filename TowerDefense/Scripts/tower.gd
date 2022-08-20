extends Node

class_name Tower

export var range_radius: float
export var damage: float
export var level: int
export var rate_of_fire: float

enum Mode {FIRST, LAST, NEAREST, FARTHEST}

var attack_timer:Timer
var can_attack: bool
var current_target
var kill_count: int
var targeting_mode = Mode.FIRST

onready var area = get_node("Area")
onready var trigger_collider = get_node("Area/CollisionShape")


func _ready() -> void:
	can_attack = true
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.wait_time = 1 / rate_of_fire
	attack_timer.connect("timeout", self, "attack_timer_timeout")
	attack_timer.start()
	trigger_collider.shape.set_radius(range_radius)


func _physics_process(_delta) -> void:
	target_enemy()
	if current_target != null and can_attack:
		attack_enemy()


func target_enemy() -> void:
	var collisions = area.get_overlapping_areas()
	for col in collisions:
		if col.is_in_group("enemy"):
			current_target = col
			break
		else:
			current_target = null


func attack_timer_timeout() -> void:
	can_attack = true
	attack_timer.stop()


func attack_enemy() -> void:
	can_attack = false
	attack_timer.wait_time = 1 / rate_of_fire
	attack_timer.start()
	var enemy_manager = current_target.get_node("../")
	enemy_manager.take_damage(self, damage)
