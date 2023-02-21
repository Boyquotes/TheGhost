extends RigidBody3D

func _physics_process(_delta):
	apply_central_force(Vector3.UP * 50 * mass)
