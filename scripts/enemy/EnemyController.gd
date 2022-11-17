extends RigidBody3D

@onready var nav_agent : NavigationAgent3D = $EnemyNavigationAgent3D
@onready var mesh : Node3D = $Mesh
@onready var raycast : RayCast3D = $RayCast3D
@onready var sm : Node3D = $EnemySM
@onready var speed = sm.speed

var randf_seed = randf_range(0.9,1.1)
var has_target = false
var stun_velocity = null

@export var health : int = 10 : 
	set(value):
		health = value
		if (health == 0):
			queue_free()

var chasing = false :
	set(value):
		chasing = value
		if value == true:
			await get_tree().create_timer(1.0).timeout
			chasing = false

func _physics_process(delta):
	if stun_velocity != null:
		mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(linear_velocity.x, linear_velocity.z), delta * 100 * randf_seed)
		linear_velocity = stun_velocity
	
	elif has_target:
		var origin = global_transform.origin
		var target = nav_agent.get_next_location()
		var velocity = (target - origin).normalized()
		linear_velocity = velocity * speed
		rotate_towards_motion(delta)

func rotate_towards_motion(delta):
	mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-linear_velocity.x, -linear_velocity.z), delta * 10 * randf_seed)

func _on_enemy_fov_player(player_location):
	if player_location == null:
		return
	if chasing == true:
		has_target = true
		nav_agent.set_target_location(player_location)
		if !nav_agent.is_target_reachable():
			nav_agent.set_target_location(global_position)
	else :
		raycast.target_position = player_location - raycast.global_position
		if raycast.is_colliding() && raycast.get_collider().is_in_group("Player"):
			chasing = true
			

func _on_enemy_navigation_agent_3d_navigation_finished():
	has_target = false

func stun(stun_source_pos):
	sm.stun_source_pos = stun_source_pos
	sm.stunned = true

func move(move_duration, direction):
	stun_velocity = direction
	await get_tree().create_timer(move_duration).timeout
	stun_velocity = null
