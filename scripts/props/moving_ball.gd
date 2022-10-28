extends Node3D

func getFuel():
	var fuel = get_node_or_null("Fuel")
	if fuel != null:
		return fuel.getFuel()
	else:
		return [0, ""]
