extends Area3D

signal coal(coal_position)

func _physics_process(_delta):
	if monitoring:
		var coal = get_overlapping_bodies()\
			.filter(func(obj): return obj.is_in_group("Coal"))
		if(coal):
			emit_signal("coal", coal[0].global_position)
