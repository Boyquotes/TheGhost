extends Area3D

signal zap(position : Vector3)

func get_zaps(obj : Node3D):
	return obj.is_in_group("Zap")

func _physics_process(_delta):
	var zaps = get_overlapping_areas().filter(get_zaps)
	if(zaps):
		emit_signal("zap", zaps[0].global_transform.origin)
