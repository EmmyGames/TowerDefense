extends KinematicBody

class_name EnemyManager

export var speed: float
export var max_health: float
export var reward: int
export var spawn_cost: int
export var exp_reward: int

enum State { WALK, ATTACK, DIE, COMPLETE}
var current_health: float
var path = []
var path_node = 0
var current_state = State.WALK
var way_points: Array
var way_point_index: int = 0

onready var gs: GameState = get_node("/root/Spatial/GameState")
onready var nav = get_node("/root/Spatial/Navigation")
onready var waypoints_node = get_node("/root/Spatial/WayPoints")
onready var audio_player = $AudioPlayer


func _ready() -> void:
	current_health = max_health
	create_path_array()
	calc_patrol_path()


func _physics_process(_delta) -> void:
	on_physics_process()


func on_physics_process() -> void:
	calc_path()


func create_path_array() -> void:
	for c in waypoints_node.get_children():
		way_points.append(c)


func calc_path() -> void:
	var distance_to_wp = way_points[way_point_index].global_transform.origin - global_transform.origin
	if path_node < path.size():
		var direction = path[path_node] - global_transform.origin
		if direction.length() < 0.5:
			path_node += 1
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)
			look_at(path[path_node], Vector3.UP)
			# If the enemy gets to the way point, point them to the next one.
			if distance_to_wp.length() < 1.1:
				if way_point_index < way_points.size() - 1:
					way_point_index += 1
				# If there are no more waypoints, they got to the end, so destroy them.
				else:
					Global.emit_signal("base_damage")
					gs.lose_lives(int(current_health))
					queue_free()
			calc_patrol_path()


func calc_patrol_path() -> void:
	if is_instance_valid(self):
		path = nav.get_simple_path(global_transform.origin, way_points[way_point_index].global_transform.origin, true)
		path_node = 0


func get_current_health() -> float:
	return current_health


func take_damage(var killer : Tower, var damage: float) -> void:
	audio_player.play_random_sound(1, 2, true)
	current_health -= damage
	if current_health <= 0 and is_instance_valid(self):
		queue_free()
		var temp_objects = get_node("/root/Spatial/TempObjects")
		audio_player.destroy_after_sound(0, 0, true)
		if audio_player.get_parent() != temp_objects:
			self.remove_child(audio_player)
			temp_objects.add_child(audio_player)
		killer.increase_exp(exp_reward)
		killer.increase_kills()
		killer.current_target = null
		gs.add_currency(reward)
