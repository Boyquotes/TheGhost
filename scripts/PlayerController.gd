extends CharacterBody3D

@export var SPEED : int = 5
var speed = SPEED
var motion = Vector3()

@onready var mesh = $body/v1

signal motion_direction (direction : Vector3)

func _apply_movement(_delta):
	_handle_move_input()
	velocity = Vector3(motion.x, 0, motion.z)
	move_and_slide()

func _handle_move_input():
	speed = 0
	motion = motion.normalized()
	if Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_up"):
		motion.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		motion.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		speed = motion.normalized().length() * SPEED
	motion = motion.normalized() * speed
	emit_signal("motion_direction", motion)
	
func _handle_move_rotation(delta):
	mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-motion.x, -motion.z), delta * 5)

