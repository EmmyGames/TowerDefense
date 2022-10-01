extends EnemyManager

class_name RangedEnemy

export var damage : float
export var range_radius: float
export var rate_of_fire: float
export(float, 180) var field_of_view: float

var attack_timer:Timer
var current_target
var can_attack: bool
var temp_speed: float
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


func on_physics_process() -> void:
	target_enemy()
	if current_state == State.ATTACK:
		look_at(current_target.global_transform.origin, Vector3.UP)
		if is_instance_valid(current_target) and can_attack:
			attack_enemy()
	elif current_state == State.WALK:
		calc_path()


func target_enemy() -> void:
	var collisions = area.get_overlapping_areas()
	for col in collisions:
		if col.is_in_group("tower"):
			current_target = col
			current_state = State.ATTACK
			return
	current_state = State.WALK
	current_target = null


func attack_timer_timeout() -> void:
	can_attack = true
	attack_timer.stop()


func attack_enemy() -> void:
	audio_player.play_random_sound(0, 0, true)
	can_attack = false
	attack_timer.wait_time = 1 / rate_of_fire
	attack_timer.start()
	var tower = current_target.get_node("../")
	tower.take_damage(self, damage)
