extends Area3D

@onready var controller = get_tree().get_first_node_in_group("Controller")
@onready var sm : StateMachine = get_tree().get_first_node_in_group("PlayerStateMachine")


signal player_body_pos (pos : Vector3, delta : float)

func _physics_process(delta):
	emit_signal("player_body_pos", global_position, delta)

var location:
	get:
		return controller.get_location()

func hit():
	if !sm.is_hit:
		controller.hit()
