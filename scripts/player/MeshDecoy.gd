extends Area3D

@onready var controller = get_tree().get_first_node_in_group("Controller")

func hit(vector3):
	controller.hit(vector3)
