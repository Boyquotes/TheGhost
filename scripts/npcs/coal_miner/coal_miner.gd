extends RigidBody3D

@onready var nav_agent : NavigationAgent3D = $CoalMinerNavigationAgent3D
@onready var sm : Node3D = $SM
@onready var fov : Area3D = $Mesh/FOV
@onready var mesh : Node3D = $Mesh
@onready var grab_position : Node3D = $Mesh/GrabPosition

const SPEED = 20

var INITIAL_POSITION = Vector3()
var speed = SPEED

var cur_coal = null

var stun_velocity = null
var on_floor = false
var needs_return = false
var grabbed = false
var needs_to_move = false

func _ready():
	INITIAL_POSITION = global_position

func _physics_process(delta):
	if on_floor && needs_to_move:
		var origin = global_transform.origin
		var target = nav_agent.get_next_path_position()
		apply_central_force((target - origin).normalized() * speed * mass)
		rotate_towards_motion(delta)

func rotate_towards_motion(delta):
	mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-linear_velocity.x, -linear_velocity.z), delta * 3.0)
	if cur_coal != null:
		cur_coal.rotation = grab_position.rotation
	
func _on_enemy_floor_detector_enemy_on_floor(boolean):
	on_floor = boolean
	

func _on_floor_detector_miner_on_floor(boolean):
	on_floor = true

func _on_fov_coal(coal_position):
	nav_agent.target_position = coal_position
	needs_to_move = true
	
func _on_stuck_timer_timeout():
	pass

func _on_target_reached():
	needs_to_move = false


func _on_grab_detector_coal_on_range(coal):
	grab(coal)

func grab(coal:RigidBody3D):
	coal.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
	coal.collision_mask = 0
	coal.global_position = grab_position.global_position
	grabbed = true


func _on_coal_miner_navigation_agent_3d_navigation_finished():
	needs_to_move = false
