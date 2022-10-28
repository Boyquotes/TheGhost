extends Node3D

func getFuel():
	var fuel = $Fuel
	if fuel != null:
		return fuel.getFuel()
	else:
		return 0
