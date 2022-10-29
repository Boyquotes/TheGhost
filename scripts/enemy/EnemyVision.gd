extends Area3D

signal player_location(target : Vector3)

func remove_not_player(obj : Node3D):
	return obj.is_in_group("Player")

func _physics_process(_delta):
	var player = get_overlapping_areas().filter(remove_not_player)
	if(player):
		emit_signal("player_location", player[0].global_position)
	else:
		emit_signal("player_location", null)
