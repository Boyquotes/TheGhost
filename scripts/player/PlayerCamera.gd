extends Node3D

var CORRECTION_SPEED : float = 2.0
@onready var OFFSET = Vector3(offset_value, 1.5 * offset_value, offset_value)
var targetPosition : Vector3 = Vector3.ZERO
@export var offset_value : float =  10.0

func _on_player_body_player_body_pos(pos, delta):
	targetPosition = pos + OFFSET
	global_position = lerp(
		global_position, 
		targetPosition, 
		CORRECTION_SPEED*delta)
