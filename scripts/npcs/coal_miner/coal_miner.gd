extends RigidBody3D

@onready var nav_agent : NavigationAgent3D = $CoalMinerNavigationAgent3D
@onready var sm : Node3D = $SM
@onready var fov : Area3D = $Mesh/FOV
@onready var grab_detector : Area3D = $Mesh/GrabDetector
@onready var mesh : Node3D = $Mesh
@onready var grab_position : Node3D = $Mesh/GrabPosition
@onready var destinations : Array

const ACCEL_FORCE = 40
const MAX_SPEED = 4.5

var INITIAL_POSITION = Vector3()

var target_coal = null:
	set(value):
		needs_to_move=true
		target_coal=value

var stop_grabbing = false:
	set(value):
		stop_grabbing =value
		if value:
			await get_tree().create_timer(1).timeout
			stop_grabbing = false

var on_floor = false
var needs_to_move = false

var grabbed = false:
	set(value):
		if not grabbed and value:
			nav_agent.target_position = destinations[randi_range(0,3)].global_position
			needs_to_move = true
		grabbed = value

func _ready():
	INITIAL_POSITION = global_position
	get_coal_position()

func _physics_process(delta):
	if destinations.is_empty():
		destinations = fov.get_overlapping_areas().filter(func(obj): return obj.is_in_group("FurnanceEntrance"))
	if not on_floor:
		return
	if needs_to_move:
		var origin = global_transform.origin
		var target = nav_agent.get_next_path_position()
		if linear_velocity.length() < MAX_SPEED:
			apply_central_force((target - origin).normalized() * ACCEL_FORCE * mass)
			rotate_towards_motion(delta)
		
		if grabbed and target_coal:
			target_coal.global_position = grab_position.global_position

func rotate_towards_motion(delta):
	mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-linear_velocity.x, -linear_velocity.z), delta * 5.0)
	if grabbed and target_coal:
		target_coal.rotation.y = lerp_angle(target_coal.rotation.y, mesh.rotation.y, delta * 15.0)

func _on_floor_detector_miner_on_floor(boolean):
	on_floor = true

func _on_target_reached():
	needs_to_move = false
	if grabbed:
		target_coal.freeze = false
		var old_coal = target_coal
		target_coal = null
		grabbed = false
		stop_grabbing = true
		
		#maybe the coal was not consumed, reset it to be pickable again
		await get_tree().create_timer(2).timeout
		if old_coal != null:
			old_coal.is_target = false
		#find new coal
			

func _on_grab_detector_coal_on_range(coal:RigidBody3D):
	if not target_coal or grabbed or stop_grabbing:
		return
	if coal.get_instance_id() == target_coal.get_instance_id():
		#pega o carvao
		coal.freeze = true
		coal.global_position = grab_position.global_position
		#pegou
		grabbed = true

func _on_fov_target_coal(coal):
	if not coal:
		#theres no coal left, should go rest
		return
	target_coal = coal

func get_coal_position():
	await get_tree().create_timer(0.5).timeout
	if target_coal and not grabbed:
		if not target_coal.is_queued_for_deletion():
			nav_agent.target_position = target_coal.global_position
	get_coal_position() 
	
func getFuel():
	return [0,"zap"]
