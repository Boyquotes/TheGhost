extends CharacterBody3D

@onready var navAgent : NavigationAgent3D = $NavigationAgent3D
@onready var sm : StateMachine = $SM
@onready var randf_seed = randf_range(0.1,1.5)
var speed = 5

@export var health : int = 10 : 
	set(value):
		health = value
		if (health == 0):
			die()

var s_velocity = null

func move_to_target():
	if s_velocity == null:
		var current_location = global_transform.origin
		var next_location = navAgent.get_next_location()
		var new_velocity = (next_location - current_location).normalized() * speed
		velocity = new_velocity
		move_and_slide()
	
func move(move_duration, direction):
	s_velocity = direction
	await get_tree().create_timer(move_duration).timeout
	s_velocity = null
	
func _physics_process(delta):
	if s_velocity != null:
		velocity = s_velocity
		move_and_slide()

func rotate_towards_motion(delta):
	rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * speed *  randf_seed)

func stun(zap_pos):
	sm.zap_pos = zap_pos
	sm.stunned = true
	
func die():
	if get_parent() :
		get_parent().remove_child(self)
