extends CharacterBody3D

@onready var navAgent : NavigationAgent3D = $NavigationAgent3D
@onready var sm : StateMachine = $SM
@onready var randf_seed = randf_range(0.5,1.0)
@onready var mesh : Node3D = $Mesh
@export @onready var raycast : RayCast3D = $RayCast3D

var speed = 3

@export var health : int = 10 : 
	set(value):
		health = value
		if (health == 0):
			die()

var stun_velocity = null

func move_to_target():
	if stun_velocity == null:
		var current_location = global_transform.origin
		var next_location = navAgent.get_next_location()
		var new_velocity = (next_location - current_location).normalized() * speed
		velocity = new_velocity
		move_and_slide()
	
func move(move_duration, direction):
	stun_velocity = direction
	await get_tree().create_timer(move_duration).timeout
	stun_velocity = null
	
func _physics_process(delta):
	if stun_velocity != null:
		mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-velocity.x, -velocity.z), delta * 100 * randf_seed)
		velocity = stun_velocity
		move_and_slide()

func rotate_towards_motion(delta):
	mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(velocity.x, velocity.z), delta * 10 * randf_seed)

func stun(zap_pos):
	sm.zap_pos = zap_pos
	sm.stunned = true
	
func die():
	if get_parent() :
		get_parent().remove_child(self)


func _on_range_body_entered(body : RigidBody3D):
	if sm.stunned :
		return
	if (body.is_in_group("Player") && !sm.attacking):
		sm.attacking = true
		await get_tree().create_timer(0.5).timeout
		body.apply_central_impulse((body.global_position - global_position).normalized() * 0.05) 
		body.get_parent().hit()
