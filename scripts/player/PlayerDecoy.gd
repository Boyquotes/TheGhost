extends Area3D

@onready var controller = get_tree().get_first_node_in_group("Controller")
@onready var smoke = get_tree().get_first_node_in_group("Smoke")

func hit(vector3):
	controller.hit(vector3)
	controller.health -= 9
	$Smoke.emitting = true

func location():
	return controller.get_location()
