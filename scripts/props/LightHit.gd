extends Area3D

signal enemy(obj)

func get_zaps(obj : Node3D):
	return obj.is_in_group("Enemy")

func _physics_process(_delta):
	var enemies = get_overlapping_areas().filter(get_zaps)
	if(enemies):
		emit_signal("enemy", enemies[0].get_parent())
	else:
		emit_signal("enemy", null)
