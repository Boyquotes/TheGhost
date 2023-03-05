extends Area3D

var targeted_coal = null:
	set(value):
		targeted_coal = value
		emit_signal("target_coal", value)

signal target_coal(coal)

func _physics_process(_delta):
	if monitoring and targeted_coal == null:
		var coals = get_overlapping_bodies()\
			.filter(func(obj): return obj.is_in_group("Coal"))\
			.filter(func(obj): return obj.is_target == false)
		if not coals.is_empty() and targeted_coal == null:
			targeted_coal = coals[randi_range(0,coals.size()-1)]
			targeted_coal.is_target = true
		elif coals.is_empty():
			targeted_coal = null
