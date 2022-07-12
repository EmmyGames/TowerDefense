extends Spatial

onready var camera: Camera = get_node("../Camera")
var ray_origin = Vector3()
var ray_end = Vector3()

#func _input(event):
#	if event is InputEventMouseMotion:
#		global_transform.origin = Vector3(event.position.x, 0, event.position.y)
#		print(event.position)

func _physics_process(delta):
	var space_state = get_world().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	print(mouse_position)
	ray_origin = camera.project_ray_origin(mouse_position)
	ray_end = ray_origin + camera.project_ray_normal(mouse_position) * 2000
	var intersection = space_state.intersect_ray(ray_origin, ray_end)
	
	if not intersection.empty():
		var pos = intersection.position
		global_transform.origin = pos
