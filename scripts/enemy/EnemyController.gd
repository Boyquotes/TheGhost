extends RigidBody3D

@onready var nav_agent : NavigationAgent3D = $EnemyNavigationAgent3D
@onready var mesh : Node3D = $Mesh
@onready var raycast : RayCast3D = $RayCast3D
@onready var sm : Node3D = $EnemySM

@onready var randf_seed = randf_range(0.5,1.0)

var speed = 5.0

var has_target = false

var stun_velocity = null

@export var health : int = 10 : 
	set(value):
		health = value
		if (health == 0):
			queue_free()

var chasing = false :
	set(value):
		if value == true:
			chasing = true
			await get_tree().create_timer(1.0).timeout
			chasing = false
		else:
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

func _on_enemy_fov_player(player):
	if chasing == true:
		has_target = true
		nav_agent.set_target_location(player.global_position)
	else :
		raycast.target_position = player.global_position - raycast.global_position
		if raycast.is_colliding() && raycast.get_collider().is_in_group("Player"):
			chasing = true
			

func _on_enemy_navigation_agent_3d_navigation_finished():
	has_target = false

func stun(zap_pos):
	sm.zap_pos = zap_pos
	sm.stunned = true

func move(move_duration, direction):
	stun_velocity = direction
	await get_tree().create_timer(move_duration).timeout
	stun_velocity = null
