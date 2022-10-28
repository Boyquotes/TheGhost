extends RigidBody3D

signal player_body_pos (pos : Vector3, delta : float)

@export var force : int = 50

const DELTA : float = 0.01

func _physics_process(delta):
	emit_signal("player_body_pos", global_position, delta)

func remove_not_moveable(obj : Node3D):
	return obj.is_in_group("Moveable")

func _on_body_entered(body):
	var moveable_objects = get_colliding_bodies().filter(remove_not_moveable)
	if moveable_objects:
		for object in moveable_objects:
			var direction = body.global_position - global_position
			object.apply_central_impulse(direction*DELTA*force) # Replace with function body.
