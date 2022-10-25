extends CharacterBody3D

@export var SPEED : int = 5
@export var ROTATION_SPEED : int = 10
var speed : float = SPEED 
var motion : Vector3 = Vector3()

const DEG = 0.52532198881
var mx = 1.0
var mz = 0.0

@onready var mesh = $PlayerBody/Mesh

signal motion_direction (direction : Vector3)

func _apply_movement(_delta):
	_handle_move_input()
	velocity = Vector3(motion.x, 0, motion.z)
	move_and_slide()

func _handle_move_input():
	speed = 0
	motion = motion.normalized()
	#TODO rotate camera around player, make static materials in front of player transparent
	if Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left") || Input.is_action_pressed("move_down") || Input.is_action_pressed("move_up"):
		motion.x = Input.get_action_strength("move_down") * mx - Input.get_action_strength("move_up") * mx - Input.get_action_strength("move_left") * mz + Input.get_action_strength("move_right") * mz 
		motion.z = Input.get_action_strength("move_down") * mz - Input.get_action_strength("move_up") * mz + Input.get_action_strength("move_left") * mx - + Input.get_action_strength("move_right") * mx
		speed = motion.normalized().length() * SPEED
		
	motion = motion.normalized() * speed
	emit_signal("motion_direction", motion)

func _handle_move_rotation(delta):
	mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-motion.x, -motion.z), delta * ROTATION_SPEED)

func _on_camera_node_cam_rotation(rot):
	print(rad_to_deg(rot))
	mx = sin(rot)
	mz = cos(rot)
