extends RigidBody3D

signal player_body_pos (position, delta)

@export var force: int = 5

const DELTA = 0.01

func _physics_process(delta):
	emit_signal("player_body_pos", global_position, delta)

func remove_not_moveable(obj : Node3D):
	return obj.is_in_group("Moveable")

func _on_controller_motion_direction(direction):
	var moveable_objects : Array[RigidBody3D] = get_colliding_bodies().filter(remove_not_moveable)
	if moveable_objects:
		for object in moveable_objects:
			#TODO input para grabar o objeto
				#mudar o estado para pushing
				#minigame que criar uma linha entre o jogador e a bola, tem que imitar o movimento do empurrao, clicando e voltando atras das costas do player e empurrando com força na bola O_O
			object.apply_central_impulse(direction*DELTA*force) # Replace with function body.
