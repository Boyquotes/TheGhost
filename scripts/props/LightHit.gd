extends Area3D

signal enemy(obj)

func get_zaps(obj : Node3D):
	return obj.is_in_group("Enemy")

func _physics_process(_delta):
	var enemies = get_overlapping_bodies().filter(get_zaps)
	if(enemies):
		emit_signal("enemy", enemies[0])
	else:
		emit_signal("enemy", null)
