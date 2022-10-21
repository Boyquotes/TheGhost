extends CharacterBody3D

@onready var navAgent : NavigationAgent3D = $NavigationAgent3D
var speed = 5

func move_to_target(delta):
	var current_location = global_transform.origin
	var next_location = navAgent.get_next_location()
	var new_velocity = (next_location - current_location).normalized() * speed
	velocity = new_velocity
	move_and_slide()

func rotate_towards_motion(delta):
	rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * speed)
