extends Area3D

signal player_location(target : Vector3)

func remove_not_player(obj : Node3D):
	return obj.is_in_group("Player")

func _process(delta):
	var player = get_overlapping_bodies().filter(remove_not_player)
	if(player):
		emit_signal("player_location", player[0].global_transform.origin)
	else:
		emit_signal("player_location", null)
