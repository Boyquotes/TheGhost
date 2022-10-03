extends CharacterBody3D

var speed = 5
var motion = Vector3()

func _apply_movement():
	_handle_move_input()
	velocity.x = motion.x * speed
	velocity.z = motion.z * speed
	move_and_slide()

func _handle_move_input():
	motion = Vector3()
	
	if Input.is_action_pressed("ui_right"):
		motion.x += 1
	if Input.is_action_pressed("ui_left"):
		motion.x += -1
	if Input.is_action_pressed("ui_up"):
		motion.z += -1
	if Input.is_action_pressed("ui_down"):
		motion.z += 1
		
	motion = motion.normalized()
