extends MeshInstance

export var angle_offset: float = -90

onready var tower_controller: Tower = get_node("../../")


func _physics_process(_delta) -> void:
	if tower_controller.current_target != null and tower_controller.current_target.is_inside_tree():
		var target_position = tower_controller.current_target.global_transform.origin
		look_at(target_position, Vector3.UP)
		var adjusted_angle = get_rotation_degrees() + Vector3(0, angle_offset, 0)
		set_rotation_degrees(adjusted_angle)
