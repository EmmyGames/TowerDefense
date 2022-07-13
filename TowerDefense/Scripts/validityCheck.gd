extends RigidBody

export (Array, Resource) var things
var isValid: bool

func _ready():
	connect("body_entered", self, "collision_detection")
	

# Make sure the group goes on the rigidbody of things that have rbs.
func collision_detection(body):
	if body.is_in_group("not_valid"):
		print("no")
		# TODO: change mats
		# It's probably going to be easier to store all the things that need different mats in a list manually.
	else:
		print("yes")
