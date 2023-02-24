extends Node3D

@onready var parent = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match get_parent().current_dir:
		"none":
			rotation.z = lerpf(rotation.z, deg_to_rad(180), 4.0*delta)
		"down":
			rotation.z = lerpf(rotation.z, deg_to_rad(140), delta)
		"up":
			rotation.z = lerpf(rotation.z, deg_to_rad(220), delta)

func push():
	if parent.current_dir == "none" and !parent.close_animation and !parent.open_animation:
		get_parent().move()
