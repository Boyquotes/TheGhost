extends CharacterBody3D

@onready var navAgent : NavigationAgent3D = $NavigationAgent3D
@onready var sm : StateMachine = $SM
var speed = 5

@export var health : int = 10 : 
	set(value):
		health = value
		if (health == 0):
			die()

func move_to_target():
	var current_location = global_transform.origin
	var next_location = navAgent.get_next_location()
	var new_velocity = (next_location - current_location).normalized() * speed
	velocity = new_velocity
	move_and_slide()

func rotate_towards_motion(delta):
	#TODO rotation on random value between 0 and 1
	rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * speed)

func stun(zap_pos):
	sm.zap_pos = zap_pos
	sm.stunned = true
	
func die():
	if get_parent() :
		get_parent().remove_child(self)
