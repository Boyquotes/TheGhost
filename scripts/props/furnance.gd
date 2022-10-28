extends Node3D

@onready var frontDoor = $Door3

func rigidBodyOnConsumer(body : RigidBody3D):
	body.freeze = true
	body.global_position = global_position - Vector3(0,3.0,0)
	print(body.get_parent().getFuel())
	body.freeze = false
	await get_tree().create_timer(1).timeout
	await frontDoor.open()
	await get_tree().create_timer(0.5).timeout
	body.apply_central_impulse(Vector3(0,0,200))
