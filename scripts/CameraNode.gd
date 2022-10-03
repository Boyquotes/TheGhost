extends Node3D

var CORRECTION_SPEED = 3
var OFFSET = Vector3(0, 10, 10)
var targetPosition


func _on_physical_body_player_body_pos(position, delta):
	targetPosition = position + OFFSET
	global_position = lerp(
		global_position, 
		targetPosition, 
		CORRECTION_SPEED*delta)
