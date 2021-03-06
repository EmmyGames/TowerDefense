extends Spatial
class_name TowerStaging

export (PackedScene) var tower
export var price: int

var ray_origin = Vector3()
var ray_end = Vector3()

onready var camera: Camera = get_node("../Camera")
onready var gs: GameState = get_node("/root/Spatial/GameState")
onready var spatial = get_node("/root/Spatial")


func _physics_process(delta):
	var space_state = get_world().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	ray_origin = camera.project_ray_origin(mouse_position)
	ray_end = ray_origin + camera.project_ray_normal(mouse_position) * 2000
	var arr: Array
	var intersection = space_state.intersect_ray(ray_origin, ray_end, arr, 1)
	
	if not intersection.empty():
		var pos = intersection.position
		global_transform.origin = pos


func _unhandled_input(event: InputEvent) -> void:
	# Prevents errors when other keys are pressed.
	if event is InputEventMouse:
		if event.is_pressed():
			if event.button_index == BUTTON_LEFT and gs.valid_placement:
				gs.current_state = gs.State.IDLE
				var new_tower = tower.instance()
				spatial.add_child(new_tower)
				new_tower.global_transform.origin = global_transform.origin
				gs.pay_for_tower(price)
				queue_free()
			if event.button_index == BUTTON_RIGHT:
				gs.current_state = gs.State.IDLE
				queue_free()
