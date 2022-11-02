extends Area3D

@onready var controller = get_tree().get_first_node_in_group("Controller")
@onready var smoke = get_tree().get_first_node_in_group("Smoke")

var location:
	get:
		return controller.get_location()

func hit(vector3):
	controller.hit(vector3)
	controller.health -= 9
	$Smoke.emitting = true
