extends RigidBody3D

@onready var nav_agent : NavigationAgent3D = $CoalMinerNavigationAgent3D
@onready var sm : Node3D = $SM
@onready var fov : Area3D = $Mesh/FOV
@onready var grab_detector : Area3D = $Mesh/GrabDetector
@onready var mesh : Node3D = $Mesh
@onready var grab_position : Node3D = $Mesh/GrabPosition
@onready var destinations : Array

const ACCEL= 1.0
const MAX_SPEED = 4.0

var INITIAL_POSITION = Vector3()

var calculated_velocity = Vector3()

var grabbed = false:
	set(value):
		if not grabbed and value:
			nav_agent.target_position = destinations[randi_range(0,3)].global_position
		grabbed = value

var target_coal = null:
	set(value):
		target_coal=value

var stop_grabbing = false:
	set(value):
		stop_grabbing =value
		if value:
			await get_tree().create_timer(1).timeout
			stop_grabbing = false

var should_rest = false:
	set(value):
		if value:
			nav_agent.target_position = INITIAL_POSITION
		await get_tree().create_timer(1.0).timeout
		should_rest = value

var on_floor = false

var rest = true

func _ready():
	INITIAL_POSITION = global_position
	get_current_coal_position()

func _integrate_forces(state):
	if freeze:
		angular_velocity = Vector3(0,0,0)
		linear_velocity = Vector3(0,0,0)
	if linear_velocity.length() < MAX_SPEED and not rest and not freeze:
		var origin = global_position
		var target = nav_agent.get_next_path_position()
		var new_velocity = (target - origin).normalized() * ACCEL
		apply_impulse(new_velocity * mass)
		
func _physics_process(delta):
	if not on_floor:
		return
	if destinations.is_empty():
		destinations = fov.get_overlapping_areas().filter(func(obj): return obj.is_in_group("FurnanceEntrance"))
	rotate_towards_motion(delta)
	if target_coal == null:
		get_new_coal()
	else:
		rest = false
		should_rest = false
		if grabbed and target_coal:
			target_coal.global_position = grab_position.global_position

func rotate_towards_motion(delta):
	mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-linear_velocity.x, -linear_velocity.z), delta * 2.0)
	if grabbed and target_coal:
		target_coal.rotation.y = lerp_angle(target_coal.rotation.y, mesh.rotation.y, delta * 5.0)

func _on_floor_detector_miner_on_floor(boolean):
	on_floor = true

func _on_target_reached():
	if should_rest:
		rest = true
		should_rest = false
	if grabbed:
		target_coal.freeze = false
		target_coal.collision_mask = 15
		target_coal.gravity_scale = 1
		var old_coal = target_coal
		target_coal = null
		grabbed = false
		stop_grabbing = true
		await get_tree().create_timer(2.0).timeout
		if old_coal != null:
			old_coal.is_target = false

func _on_grab_detector_coal_on_range(coal:RigidBody3D):
	if not target_coal or grabbed or stop_grabbing:
		return
	if coal.get_instance_id() == target_coal.get_instance_id():
		freeze = true
		target_coal.collision_mask = 0
		target_coal.gravity_scale = 0
		target_coal.angular_velocity = Vector3(0,0,0)
		target_coal.linear_velocity = Vector3(0,0,0)
		target_coal.freeze = true
		grabbed = true
		await get_tree().create_timer(0.35).timeout
		target_coal.global_position = grab_position.global_position
		await get_tree().create_timer(0.5).timeout
		freeze = false

func get_new_coal():
	var coals = fov.get_overlapping_bodies()\
		.filter(func(obj): return obj.is_in_group("Coal"))\
		.filter(func(obj): return obj.is_target == false)
	if not coals.is_empty():
		should_rest = false
		rest = false
		target_coal = coals[randi_range(0,coals.size()-1)]
		nav_agent.target_position = target_coal.global_position
		target_coal.is_target = true
	elif coals.is_empty():
		target_coal = null
		should_rest = true

func get_current_coal_position():
	await get_tree().create_timer(0.5).timeout
	if target_coal!= null and not grabbed:
		if not target_coal.is_queued_for_deletion():
			nav_agent.target_position = target_coal.global_position
	get_current_coal_position() 
