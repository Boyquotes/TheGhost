extends Area3D

@onready var controller = get_tree().get_first_node_in_group("Controller")
@onready var smoke = get_tree().get_first_node_in_group("Smoke")
@onready var sm : StateMachine = get_tree().get_first_node_in_group("PlayerStateMachine")

var location:
	get:
		return controller.get_location()

func hit():
	if !sm.is_hit:
		controller.hit()
		controller.health -= 9
		$Smoke.emitting = true
