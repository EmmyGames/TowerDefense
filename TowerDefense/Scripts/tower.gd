extends Node

class_name Tower

export var range_radius: float
export var damage: float
export var level: int
export var rate_of_fire: float

var attack_timer:Timer
enum Mode {FIRST, LAST, NEAREST, FARTHEST}
var current_target
var targeting_mode = Mode.FIRST
var kill_count: int
var can_attack: bool

onready var area = get_node("Area")
onready var trigger_collider = get_node("Area/CollisionShape")


func _ready():
	can_attack = true
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.wait_time = 1 / rate_of_fire
	attack_timer.connect("timeout", self, "attack_timer_timeout")
	attack_timer.start()
	#trigger_collider.set_scale(Vector3(range_radius, trigger_collider.get_scale().y, range_radius))
	trigger_collider.shape.set_radius(range_radius)
	

func _physics_process(delta):
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


func attack_timer_timeout():
	can_attack = true
	attack_timer.stop()
	

func attack_enemy() -> void:
	can_attack = false
	attack_timer.wait_time = 1 / rate_of_fire
	attack_timer.start()
	var enemy_manager = current_target.get_node("../")
	enemy_manager.take_damage(self, damage)
