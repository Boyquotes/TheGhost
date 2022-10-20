extends CharacterBody3D

@onready var navAgent : NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta):
	var colisions = 0
	var current_location = global_transform.origin
	var next_location = navAgent.get_next_location()
	var new_velocity = (next_location - current_location).normalized() * 5
	navAgent.set_velocity(velocity)
	rotation.y = lerp_angle(rotation.y, atan2(-new_velocity.x, -new_velocity.z), delta * 5)
	velocity = velocity.move_toward(new_velocity, .25)
	if get_last_slide_collision(): 
		colisions = get_last_slide_collision().get_collision_count()
	if colisions > 1:
		#se colidiu, parar por um segundo
		pass
	move_and_slide()

	
func _on_range_area_player_location(target):
	if(target != null):
		navAgent.set_target_location(target) # Replace with function body.
