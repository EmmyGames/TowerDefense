extends Node

class_name Tower

export var range_radius: float
export var damage: float
export var level: int
export var rate_of_fire: float

enum Mode {FIRST, LAST, NEAREST, FARTHEST}
var current_target
var targeting_mode = Mode.FIRST
var kill_count: int

onready var area = get_node("Area")
onready var trigger_collider = get_node("Area/CollisionShape")

func _ready():
	#trigger_collider.set_scale(Vector3(range_radius, trigger_collider.get_scale().y, range_radius))
	trigger_collider.shape.set_radius(range_radius)

func _physics_process(delta):
	target_enemy()
	# if current_target is not null
	# attack enemy every rate_of_fire

func target_enemy() -> void:
	# print("default")
	var collisions = area.get_overlapping_areas()
	for col in collisions:
		if col.is_in_group("enemy"):
			current_target = col
			break
		else:
			current_target = null


func attack_enemy() -> void:
	pass
