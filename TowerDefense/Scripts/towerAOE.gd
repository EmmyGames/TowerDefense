extends Tower

export var attack : PackedScene


func attack_enemy() -> void:
	audio_player.play_random_sound(0, 0, true)
	can_attack = false
	attack_timer.wait_time = 1 / rate_of_fire
	attack_timer.start()
	var mf = $Turret/SwivelTray/Top/Barrels/MuzzleFlash
	mf.emitting = true
	var enemy_manager = current_target.get_node("../")
	var new_attack = attack.instance()
	get_node("/root/Spatial").add_child(new_attack)
	if is_instance_valid(current_target):
		new_attack.global_transform.origin = current_target.global_transform.origin
		new_attack.get_node("Area").tower = self
		# The current target gets damaged twice for a direct hit.
		enemy_manager.take_damage(self, damage)
