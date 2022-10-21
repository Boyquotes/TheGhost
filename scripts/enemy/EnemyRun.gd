extends Area3D

signal light(position : Vector3)

func get_light(obj : Node3D):
	return obj.is_in_group("Light")

func _physics_process(_delta):
	var light = get_overlapping_areas().filter(get_light)
	if(light):
		emit_signal("light", light[0].global_transform.origin)
	else:
		emit_signal("light", null)
