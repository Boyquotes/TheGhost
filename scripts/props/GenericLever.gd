extends Node3D

signal lever_switch (current_switch : String)

@export var current_switch = "off":
	set(value):
		emit_signal("lever_switch", value)
		current_switch=value


func _physics_process(delta):
	match current_switch:
		"off":
			rotation.z = lerp_angle(rotation.z, deg_to_rad(-45), 8.0*delta)
		"on":
			rotation.z = lerp_angle(rotation.z, deg_to_rad(-135), 8.0*delta)

func push():
	if current_switch == "off":
		current_switch = "on"
	else:
		current_switch = "off"

