extends RigidBody

var isValid: bool

func _ready():
	connect("body_entered", self, "collision_detection")
	

func collision_detection(body):
	print("Col")
