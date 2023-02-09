extends AudioStreamPlayer3D

func _physics_process(_delta):
	if !playing:
		play(randf_range(0.0,5.0))
