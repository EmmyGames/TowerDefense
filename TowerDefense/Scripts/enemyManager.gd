extends KinematicBody


export var speed: float
enum { DAMAGED, WALK, DIE, COMPLETE }
var path = []
var path_node = 0
onready var nav = get_node("/root/Spatial/Navigation")
var current_state = WALK
var way_points
var way_point_index: int = 0

onready var wp_01 = get_node("/root/Spatial/WP1")
onready var wp_02 = get_node("/root/Spatial/WP2")
onready var wp_03 = get_node("/root/Spatial/WP3")
onready var wp_04 = get_node("/root/Spatial/WP4")


func _ready():
	create_path_array()
	calc_patrol_path()

func _physics_process(delta):
	calc_path()


func create_path_array():
	way_points = [wp_01, wp_02, wp_03, wp_04]


func calc_path():
	var distance_to_wp = way_points[way_point_index].global_transform.origin - global_transform.origin
	if path_node < path.size():
		var direction = path[path_node] - global_transform.origin
		if direction.length() < 1:
			path_node += 1
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)
			look_at(path[path_node], Vector3.UP)
			if distance_to_wp.length() < 2:
				way_point_index += 1
			calc_patrol_path()
	else:
		current_state = COMPLETE


func calc_patrol_path():
	path = nav.get_simple_path(global_transform.origin, way_points[way_point_index].global_transform.origin, true)
	path_node = 0
