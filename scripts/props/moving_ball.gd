extends Node3D

var INITIAL_POSITION = Vector3()

func _ready():
	INITIAL_POSITION = get_parent().global_position

func getFuel():
	var fuel = get_node_or_null("Fuel")
	if fuel != null:
		return fuel.getFuel()
	else:
		return [0, ""]
