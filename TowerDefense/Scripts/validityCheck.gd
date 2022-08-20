extends RigidBody

export var invalid_material: Material
export var valid_material: Material

var meshes: Array

onready var base: MeshInstance = get_node("../Base")
onready var gs: GameState = get_node("/root/Spatial/GameState")


func _ready():
	connect("body_entered", self, "collision_detection")


func collision_detection(body) -> void:
	if body.is_in_group("not_valid"):
		change_all_meshes(invalid_material)
		gs.valid_placement = false
	else:
		change_all_meshes(valid_material)
		gs.valid_placement = true


func change_all_meshes(var material: Material) -> void:
	meshes = get_tree().get_nodes_in_group("mesh")
	for mesh in meshes:
		mesh.material_override = material
