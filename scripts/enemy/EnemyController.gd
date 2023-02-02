extends RigidBody3D

@onready var nav_agent : NavigationAgent3D = $EnemyNavigationAgent3D
@onready var mesh : Node3D = $Mesh
@onready var raycast : RayCast3D = $RayCast3D
@onready var sm : Node3D = $EnemySM

var speed = 3.5

var randf_seed = randf_range(0.8,1.2)
var has_target = false
var stun_velocity = null
var on_floor = false

@export var health : int = 10 : 
	set(value):
		health = value
		if (health == 0):
			queue_free()

var chasing = false :
	set(value):
		chasing = value
		if value == true:
			await get_tree().create_timer(0.5).timeout
			chasing = false

func _physics_process(delta):
	if stun_velocity:
		mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(linear_velocity.x, linear_velocity.z), delta * 100.0)
		apply_central_impulse(Vector3(stun_velocity.x, stun_velocity.y, stun_velocity.z)* 1000.0)
		return

	if has_target && on_floor:
		var origin = global_transform.origin
		var target = nav_agent.get_next_path_position()
		#nav_agent.set_velocity((target - origin).normalized() * speed * randf_seed)
		linear_velocity = (target - origin).normalized() * speed * randf_seed
		rotate_towards_motion(delta)

func rotate_towards_motion(delta):
	mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-linear_velocity.x, -linear_velocity.z), delta * 5.0 * randf_seed * randf_seed)

func _on_enemy_fov_player(player_location):
	if player_location == null:
		raycast.debug_shape_custom_color = Color(1,0,0,1)
		return
	if chasing == true:
		nav_agent.target_position = player_location
		if !nav_agent.is_target_reachable():
			return
		has_target = true
	else :
		var target = player_location - raycast.global_position #- Vector3(player_location.x,0,player_location.z)
		var ray_size_sqrd = target.length_squared()
		raycast.target_position = 3000000 * target/ray_size_sqrd
		if raycast.is_colliding() && raycast.get_collider().is_in_group("Player"):
			raycast.debug_shape_custom_color = Color(0,0,1,1)
			chasing = true
			return
		if raycast.is_colliding():
			raycast.debug_shape_custom_color = Color(0,1,0,1)

func _on_enemy_navigation_agent_3d_navigation_finished():
	has_target = false

func stun(stun_source_pos):
	sm.stun_source_pos = stun_source_pos
	sm.stunned = true

func move(move_duration, direction):
	stun_velocity = direction
	await get_tree().create_timer(move_duration).timeout
	stun_velocity = null

func _on_enemy_floor_detector_enemy_on_floor(boolean):
	on_floor = boolean


func _on_enemy_navigation_agent_3d_velocity_computed(safe_velocity):
	linear_velocity = safe_velocity
