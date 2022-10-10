extends CharacterBody3D

var speed = 5
var motion = Vector3()

signal motion_direction (direction : Vector3)

func _apply_movement(delta):
	_handle_move_input()
	velocity = Vector3(motion.x * speed, 0, motion.z * speed)
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
	emit_signal("motion_direction", motion)
	
func _handle_move_rotation(delta):
	$body/v1.rotation.y = lerp_angle($body/v1.rotation.y, atan2(-velocity.x, -velocity.z), delta * 10)
