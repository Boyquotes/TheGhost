extends Node3D

@export var offset_value : float =  20.0
@export var CORRECTION_SPEED : float = 5.0
@onready var OFFSET = Vector3(0, offset_value, offset_value)

var targetPosition : Vector3 = Vector3.ZERO
var locked = false

signal cam_rotation(rot : float)

func _ready():
	emit_signal("cam_rotation", rotation.y)

@export var rot : float = 0:
	set(value):
		if(OFFSET != null):
			rot = value
			emit_signal("cam_rotation", rot)
			var mx = sin(value)
			var mz = cos(value)
			OFFSET.x = mx * offset_value
			OFFSET.z = mz * offset_value

func _on_player_body_player_body_pos(pos, delta):
	targetPosition = pos + OFFSET
	global_position = lerp(
		global_position, 
		targetPosition, 
		CORRECTION_SPEED*delta)
	rotation.y = lerp_angle(rotation.y, rot, CORRECTION_SPEED*delta)

func _input(event):
	if event.is_action("move_cam_left") || event.is_action("move_cam_right"):
		if event.get_action_strength("move_cam_left") > 0.7:
			rotate_camera(1)
			locked = true
		if Input.is_action_just_released("move_cam_left"):
			locked = false
		if event.get_action_strength("move_cam_right") > 0.7:
			rotate_camera(-1)
			locked = true
		if Input.is_action_just_released("move_cam_right"):
			locked = false

func rotate_camera(dir):
	if !locked :
		rot+=int(dir / TAU * 8) / 8.0 * TAU


func _on_mesh_player_body_pos(pos, delta):
	targetPosition = pos + OFFSET
	global_position = lerp(
		global_position, 
		targetPosition, 
		CORRECTION_SPEED*delta)
	rotation.y = lerp_angle(rotation.y, rot, CORRECTION_SPEED*delta)
