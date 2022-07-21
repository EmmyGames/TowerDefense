extends KinematicBody

export var speed: float
export var max_health: int

enum { DAMAGED, WALK, DIE, COMPLETE }
var current_health: int
var path = []
var path_node = 0
var current_state = WALK
var way_points
var way_point_index: int = 0

onready var nav = get_node("/root/Spatial/Navigation")
onready var gs: GameState = get_node("/root/Spatial/GameState")
onready var wp_01 = get_node("/root/Spatial/WayPoints/WP1")
onready var wp_02 = get_node("/root/Spatial/WayPoints/WP2")
onready var wp_03 = get_node("/root/Spatial/WayPoints/WP3")
onready var wp_04 = get_node("/root/Spatial/WayPoints/WP4")


func _ready():
	current_health = max_health
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
			#var look_at_position = Vector3(path[path_node].x, 0, path[path_node].z)
			look_at(path[path_node], Vector3.UP)
			# If the enemy gets to the way point, point them to the next one.
			if distance_to_wp.length() < 2:
				if way_point_index < way_points.size() - 1:
					way_point_index += 1
				# If there are no more waypoints, they got to the end, so destroy them.
				else:
					# TODO: Deal damage to lives based on health.
					gs.lose_lives(current_health)
					queue_free()
			calc_patrol_path()


func calc_patrol_path():
	path = nav.get_simple_path(global_transform.origin, way_points[way_point_index].global_transform.origin, true)
	path_node = 0
