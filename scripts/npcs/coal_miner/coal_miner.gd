extends RigidBody3D

@onready var nav_agent : NavigationAgent3D = $CoalMinerNavigationAgent3D
@onready var sm : Node3D = $SM
@onready var fov : Area3D = $Mesh/FOV
@onready var mesh : Node3D = $Mesh
@onready var grab_position : Node3D = $Mesh/GrabPosition
@onready var destinations : Array

const SPEED = 40

var INITIAL_POSITION = Vector3()
var speed = SPEED

var target_coal = null:
	set(value):
		target_coal = value
		if value != null:
			get_coal_position()

var stun_velocity = null
var on_floor = false
var needs_return = false

var grabbed = false :
	set(value):
		if not grabbed and value:
			nav_agent.target_position = destinations[randi_range(0,3)].global_position
			needs_to_move = true
		grabbed = value

var needs_to_move = false

func _ready():
	INITIAL_POSITION = global_position

func _physics_process(delta):
	if destinations.is_empty():
		destinations = fov.get_overlapping_areas().filter(func(obj): return obj.is_in_group("FurnanceEntrance"))
	if target_coal != null:
		needs_to_move = true
	print(target_coal)
	if on_floor && needs_to_move:
		var origin = global_transform.origin
		var target = nav_agent.get_next_path_position()
		if !freeze:
			apply_central_force((target - origin).normalized() * speed * mass)
		rotate_towards_motion(delta)
	if grabbed:
		target_coal.global_position.x = lerpf(target_coal.global_position.x, grab_position.global_position.x, delta * 20.0)
		target_coal.global_position.y = lerpf(target_coal.global_position.y, grab_position.global_position.y, delta * 20.0)
		target_coal.global_position.z = lerpf(target_coal.global_position.z, grab_position.global_position.z, delta * 20.0)

func rotate_towards_motion(delta):
	mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-linear_velocity.x, -linear_velocity.z), delta * 5.0)
	if grabbed:
		target_coal.rotation.y = lerp_angle(target_coal.rotation.y, mesh.rotation.y, delta * 15.0)
	
func _on_enemy_floor_detector_enemy_on_floor(boolean):
	on_floor = boolean

func _on_floor_detector_miner_on_floor(boolean):
	on_floor = true

func _on_stuck_timer_timeout():
	pass

func _on_target_reached():
	needs_to_move = false
	if grabbed:
		target_coal.collision_mask = 1
		target_coal.freeze = false
		grabbed = false
		freeze=true
		await get_tree().create_timer(1.0).timeout
		freeze=false
		

func _on_grab_detector_coal_on_range(coal:RigidBody3D):
	if !target_coal:
		return
	if coal.get_instance_id() == target_coal.get_instance_id():
		if !grabbed:
			grab(coal)

func grab(coal:RigidBody3D):
	coal.freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
	coal.collision_mask = 0
	coal.freeze = true
	grabbed = true
	freeze = true
	await get_tree().create_timer(1).timeout
	freeze = false


func _on_coal_miner_navigation_agent_3d_navigation_finished():
	needs_to_move = false


func _on_fov_target_coal(coal):
	if not grabbed and coal != null:
		nav_agent.target_position = coal.global_position
		target_coal = coal
		needs_to_move = true

func get_coal_position():
	await get_tree().create_timer(1).timeout
	if target_coal != null and not grabbed:
		nav_agent.target_position = target_coal.global_position
	get_coal_position()

func getFuel():
	return [0,"zap"]
