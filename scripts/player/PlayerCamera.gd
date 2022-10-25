extends Node3D

var CORRECTION_SPEED : float = 4.0
@onready var OFFSET = Vector3(0, offset_value, offset_value)
var targetPosition : Vector3 = Vector3.ZERO
@export var offset_value : float =  20.0

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

func _physics_process(delta):
	if Input.is_action_pressed("move_cam_left") || Input.is_action_pressed("move_cam_right"):
		rot += (Input.get_action_raw_strength("move_cam_left") - Input.get_action_raw_strength("move_cam_right")) * 0.05
		
