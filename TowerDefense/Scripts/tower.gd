extends Node

class_name Tower

export var range_radius: float
export var damage: float
export var rate_of_fire: float
export (Array, PackedScene) var upgrades

enum Mode {FIRST, LAST, NEAREST, FARTHEST}

var attack_timer:Timer
var can_attack: bool
var current_target
var exp_current: int = 0
var exp_total: int
var kill_count: int
var level: int
var price_invested: int = 0
var targeting_mode = Mode.FIRST
var upgrade_index: int = 0
var is_menu_up: bool = false


onready var gs = get_node("/root/Spatial/GameState")
onready var area = get_node("Area")
onready var trigger_collider = get_node("Area/CollisionShape")
onready var range_indicator = $Turret/Base/RangeIndicator


func _ready() -> void:
	exp_total = get_total_exp(level)
	can_attack = true
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.wait_time = 1 / rate_of_fire
	attack_timer.connect("timeout", self, "attack_timer_timeout")
	attack_timer.start()
	trigger_collider.shape.set_radius(range_radius)


func _physics_process(_delta) -> void:
	target_enemy()
	if is_instance_valid(current_target) and can_attack:
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
	var mf = $Turret/SwivelTray/Top/Barrel/MuzzleFlash
	mf.emitting = true
	var enemy_manager = current_target.get_node("../")
	enemy_manager.take_damage(self, damage)


func increase_kills() -> void:
	kill_count += 1
	if is_menu_up:
		gs.set_tower_kills()


func _on_RigidBody_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed == true:
			gs.set_tower_menu(self)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and gs.current_state == gs.State.IDLE:
		if event.button_index == BUTTON_RIGHT and event.pressed == false:
			gs.unset_tower_menu()


func update_range() -> void:
	trigger_collider.shape.set_radius(range_radius)


func get_total_exp(var _level: int) -> int:
	# TODO: Make a better equation for this later. This is a test equation.
	return 100 * _level
	

func level_up():
	if exp_current >= exp_total:
		exp_current -= exp_total
		level += 1
		exp_total = get_total_exp(level)


func increase_exp(var xp: int):
	exp_current += xp
	level_up()
