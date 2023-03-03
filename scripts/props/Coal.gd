extends RigidBody3D

@export var health : int = 10 : 
	set(value):
		health = value
		if (health <= 0):
			queue_free()


func getFuel():
	var fuel = health
	health = 0
	return [fuel,"zap"]
