extends RigidBody3D

@onready var nav_agent : NavigationAgent3D = $EnemyNavigationAgent3D
@onready var mesh : Node3D = $EnemySM/Mesh
@onready var sm : Node3D = $EnemySM
@onready var fov : Area3D = $EnemySM/Mesh/EnemyFOV
@onready var head : Node3D = $EnemySM/Mesh/Head

const SPEED = 4.0

var INITIAL_POSITION = Vector3()
var direction = Vector3.ZERO
var speed = SPEED

var calculated_velocity = Vector3.ZERO

var has_target = false
var on_floor = false

var passing = false:
	set(value):
		passing = value
		if (value):
			await get_tree().create_timer(1.875)
			passing = false

var needs_to_force_foward = false:
	set(value):
		needs_to_force_foward = value
		if value:
			collision_mask = 3
			await get_tree().create_timer(0.35).timeout
			collision_mask = 7
			needs_to_force_foward = false

var chasing = false :
	set(value):
		chasing = value
		if value == true:
			await get_tree().create_timer(1.5).timeout
			chasing = false

func _ready():
	INITIAL_POSITION = global_position

func _physics_process(delta):
	if has_target && on_floor:
		rotate_towards_motion(delta)

func _integrate_forces(state):
	if needs_to_force_foward:
		nav_agent.set_velocity(Vector3(direction.x * 8.9, 0, direction.z * 8.9))
		linear_velocity = calculated_velocity
		return
	if has_target && on_floor and linear_velocity.length() <= SPEED and sm.state !=4:
		var origin = global_transform.origin
		var target = nav_agent.get_next_path_position()
		direction = (target - origin).normalized()
		var velocity = linear_velocity + (target - origin).normalized() * speed
		nav_agent.set_velocity(Vector3(velocity.x, 0, velocity.z))
		linear_velocity = calculated_velocity

func rotate_towards_motion(delta):
	mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-linear_velocity.x, -linear_velocity.z), delta * 5.0)

func _on_enemy_fov_player(player_location):
	if player_location == null:
		return
	if chasing == true:
		nav_agent.target_position = player_location
		if !nav_agent.is_target_reachable():
			return
		has_target = true
	else :
		chasing = true
		if (global_position - player_location).length() < 20:
			mesh.visible = true
		else:
			mesh.visible = false
		return

func _on_enemy_navigation_agent_3d_navigation_finished():
	chasing = false
	has_target = false


func _on_enemy_floor_detector_enemy_on_floor(boolean):
	on_floor = boolean

func player_death():
	chasing = false
	nav_agent.target_position = INITIAL_POSITION
	global_position = INITIAL_POSITION
	has_target = false


func _on_enemy_navigation_agent_3d_velocity_computed(safe_velocity):
	calculated_velocity = safe_velocity
