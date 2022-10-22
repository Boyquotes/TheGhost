extends Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$FollowBody.global_transform.origin = $RigidBody3D.global_transform.origin
