extends Node3D

@export var offset_value : float =  20.0
@export var CORRECTION_SPEED : float = 9.0

@onready var OFFSET = Vector3(0, offset_value, offset_value)

@onready var camera = get_tree().get_first_node_in_group("PlayerCamera")
@onready var fakeCamera = get_tree().get_first_node_in_group("FakeCamera")

const START_ROT = -2.35619449019234
@export var rot : float = 0:
	set(value):
		rot = value
		if(OFFSET != null):
			emit_signal("cam_rotation", value)
			var mx = sin(value)
			var mz = cos(value)
			OFFSET.x = mx * offset_value
			OFFSET.z = mz * offset_value

var targetPosition : Vector3 = Vector3.ZERO
var locked = false

signal cam_rotation(rot : float)

func _ready():
	rot = START_ROT

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

func _on_player_pos(pos, delta):
	targetPosition = pos + OFFSET
	camera.global_position = lerp(
		camera.global_position, 
		targetPosition, 
		CORRECTION_SPEED*delta)
	camera.rotation.y = lerp_angle(camera.rotation.y, rot, CORRECTION_SPEED*delta)
	
	fakeCamera.global_position = pos+Vector3.UP*2.3
	fakeCamera.rotation.y = rot


func _on_player_controller_player_spawn(pos):
	targetPosition = pos + OFFSET
	camera.global_position = targetPosition
