extends Spatial


func _ready() -> void:
	Global.connect("base_damage", self, "damage_sound")


func damage_sound() -> void:
	$SoundEffects.play_random_sound(0, 0, true)
