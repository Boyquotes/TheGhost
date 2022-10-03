extends Node3D

@onready var test = get_node("../Player")
@onready var player = get_node("../Player/PhysicalBody")
var CORRECTION_SPEED = 3
var OFFSET = Vector3(0, 10, 10)
var targetPosition

func _physics_process(delta):
	camera_corretion(delta)

func camera_corretion(delta):
	targetPosition = player.global_position + OFFSET
	global_position = lerp(
		global_position, 
		targetPosition, 
		CORRECTION_SPEED*delta)
