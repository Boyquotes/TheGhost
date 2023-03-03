extends Area3D

signal miner_on_floor(boolean)

func _physics_process(_delta):
	var floor_area = get_overlapping_bodies()
	if(floor_area):
		emit_signal("miner_on_floor", true)
	else:
		emit_signal("miner_on_floor", false)
