extends Area3D

signal coal_on_range(coal)

func _physics_process(_delta):
	var coals = get_overlapping_bodies()\
			.filter(func(obj): return obj.is_in_group("Coal"))
	if coals :
		emit_signal("coal_on_range", coals[0])
