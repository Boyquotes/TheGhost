extends Node3D

@onready 
var body = get_parent().get_node("RigidBody3D")

func _physics_process(delta):
	global_transform.origin = body.global_transform.origin
