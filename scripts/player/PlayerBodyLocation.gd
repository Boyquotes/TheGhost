extends Area3D

@onready var controller = get_tree().get_first_node_in_group("Controller")
@onready var smoke = get_tree().get_first_node_in_group("Smoke")
@onready var sm : StateMachine = get_tree().get_first_node_in_group("PlayerStateMachine")
@onready var hitSound : AudioStreamPlayer3D = $HitSound

signal player_body_pos (pos : Vector3, delta : float)

func _physics_process(delta):
	emit_signal("player_body_pos", global_position, delta)

var location:
	get:
		return controller.get_location()

func hit():
	if !sm.is_hit:
		hitSound.play(0.0)
		controller.hit()
		controller.health -= 9
		$Smoke.emitting = true
