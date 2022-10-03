extends Node3D

@onready var player = get_node("../PhysicalBody")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = player.global_position + Vector3(0, 10, 10)
