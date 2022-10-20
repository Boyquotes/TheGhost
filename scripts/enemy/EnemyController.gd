extends CharacterBody3D

@onready var navAgent : NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = navAgent.get_next_location()
	var new_velocity = (next_location - current_location).normalized() * 5
	rotation.y = lerp_angle(rotation.y, atan2(-new_velocity.x, -new_velocity.z), delta * 5)
	velocity = velocity.move_toward(new_velocity, .25)
	navAgent.set_velocity(velocity)
	move_and_slide()

	
func _on_range_area_player_location(target):
	if(target != null):
		navAgent.set_target_location(target) # Replace with function body.
