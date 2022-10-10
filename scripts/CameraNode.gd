extends Node3D

var CORRECTION_SPEED = 3
@onready var OFFSET = Vector3(0, offset_value, offset_value)
var targetPosition
@export var offset_value:float =  10


func _on_physical_body_player_body_pos(pos, delta):
	targetPosition = pos + OFFSET
	global_position = lerp(
		global_position, 
		targetPosition, 
		CORRECTION_SPEED*delta)
