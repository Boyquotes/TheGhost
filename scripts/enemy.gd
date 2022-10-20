extends CharacterBody3D

#var motion : Vector3

func move_to(destination):
	#if(destination):
		#motion = destination - global_position
		#velocity = (destination - global_position).normalized() * 5
		#move_and_slide()
		#if (fmod(rad_to_deg(atan2(-motion.x, -motion.z) - rotation.y), 360) < 10):
		pass

func _physics_process(delta):
	#rotation.y = lerp_angle(rotation.y, atan2(-motion.x, -motion.z), delta)
	pass
