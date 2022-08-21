extends Area

var tower : Tower


func damage_enemy(var collisions : Array) -> void:
	for col in collisions:
		if col.is_in_group("enemy"):
			var enemy_manager = col.get_node("../")
			enemy_manager.take_damage(tower, tower.damage)
	get_parent().queue_free()


func _physics_process(delta):
	var collisions = get_overlapping_areas()
	damage_enemy(collisions)
