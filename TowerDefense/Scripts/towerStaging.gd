extends Spatial

func _input(event):
	if event is InputEventMouseMotion:
		global_transform.origin = Vector3(event.position.x, 0, event.position.y)
		print(event.position)
