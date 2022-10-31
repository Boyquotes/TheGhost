extends Area3D

signal player(player)

func remove_not_player(obj : Node3D):
	return obj.is_in_group("Player")

func _physics_process(_delta):
	var player = get_overlapping_areas().filter(remove_not_player)
	if(player):
		emit_signal("player", player[0])
