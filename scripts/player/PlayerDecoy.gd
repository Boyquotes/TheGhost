extends Area3D

@onready var controller = get_tree().get_first_node_in_group("Controller")

var has_body = true :
	set(value):
		if value == true:
			has_body = true
		if value == false:
			has_body = false
			await get_tree().create_timer(2).timeout
			has_body = true

func hit(vector3):
	has_body = false
	controller.hit(vector3)
	$Smoke.emitting = true


func location():
	return controller.get_location()
