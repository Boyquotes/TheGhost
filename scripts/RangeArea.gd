extends Area3D

signal is_player_on_range(position : Vector3)

func remove_not_player(obj : Node3D):
	return obj.is_in_group("Player")

func _process(delta):
	var player = get_overlapping_bodies().filter(remove_not_player)
	if(player):
		emit_signal("is_player_on_range", player[0].global_position)
	else:
		emit_signal("is_player_on_range", null)
