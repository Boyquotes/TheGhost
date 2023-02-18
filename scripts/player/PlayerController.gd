extends RigidBody3D
@export var MAX_SPEED : float = 5.0
@export var SPEED : float = 1000.0
@export var ROTATION_SPEED : int = 8

var INITIAL_MASS = mass

var INITIAL_POSITION = Vector3()

var jumping = false

var on_floor = true :
	set(value):
		on_floor = value
		sm.on_floor = value

var speed : float = SPEED 
var motion = Vector3()
var health = 10 :
	set(value):
		if (value < 0):
			value = 0
		health = value
		sm.health = value

var mx = 1.0
var mz = 0.0

@onready var sm = $SM
@onready var mesh_decoy = $MeshDecoy
@onready var mesh_decoy_location = $"MeshDecoy/Armature/Skeleton3D/Physical Bone Root/BodyLocation"
@onready var mesh = $Mesh
@onready var pushArea : Area3D = $Mesh/Push
@onready var ui : Label = $VBoxContainer/Label
@onready var player_text : Label3D = $MeshDecoy/Label3D
@onready var floor_detector : Area3D = $FloorDetector

signal player_spawn (pos : Vector3)

func _ready():
	INITIAL_POSITION = get_parent().global_position

func _apply_movement():
	if on_floor && linear_velocity.length() < MAX_SPEED && is_move_input():
		apply_central_impulse(Vector3(motion.x, 333.3, motion.z))
	
func _handle_move_input():
	speed = 0
	if !is_move_input():
		return
	motion.x = Input.get_action_strength("move_down") * mx - Input.get_action_strength("move_up") * mx - Input.get_action_strength("move_left") * mz + Input.get_action_strength("move_right") * mz 
	motion.z = Input.get_action_strength("move_down") * mz - Input.get_action_strength("move_up") * mz + Input.get_action_strength("move_left") * mx - + Input.get_action_strength("move_right") * mx
	if linear_velocity.length() < 1:
		speed = motion.normalized().length() * SPEED * 15
	if linear_velocity.length() < 2:
		speed = motion.normalized().length() * SPEED * 0.1
	if linear_velocity.length() < 3:
		speed = motion.normalized().length() * SPEED * 0.2
	if linear_velocity.length() < 4:
		speed = motion.normalized().length() * SPEED * 0.5
	if linear_velocity.length() < 4.5:
		speed = motion.normalized().length() * SPEED * 0.7
	else:
		speed = motion.normalized().length() * SPEED
	motion = motion.normalized() * speed

func _input(event):
	if event.is_action_pressed("push"):
		push()
	if event.is_action_pressed("jump") && !sm.is_hit && sm.state in [1,2,7] && !jumping:
		jump()


func _handle_move_rotation(delta):
	if motion.length() < 10 || jumping || !is_move_input():
		return
	if !sm.is_hit :
		mesh_decoy.rotation.y = lerp_angle(mesh_decoy.rotation.y, atan2(-motion.x, -motion.z), delta * ROTATION_SPEED)
	mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-motion.x, -motion.z), delta * ROTATION_SPEED)

func _on_camera_node_cam_rotation(rot):
	mx = sin(rot)
	mz = cos(rot)

func hit():
	sm.is_hit = true
	mesh_decoy.hit()
	Engine.time_scale = 0.3
	await get_tree().create_timer(0.2).timeout
	Engine.time_scale = 1.0

func ik():
	reset()

func reset():
	sm.set_state(5)
	emit_signal("player_spawn", INITIAL_POSITION)
	global_position = INITIAL_POSITION

func get_location():
	if sm.is_block == false:
		return mesh_decoy_location.global_position
	else:
		return null

func push():
	if sm.is_hit || sm.is_pushing :
			return
	var objsToPush = pushArea.get_overlapping_bodies().filter(func(obj): return obj.is_in_group("Moveable"))
	if objsToPush.is_empty():
		return
	objsToPush.sort_custom(func(a, b): return global_position - a.global_position < global_position - b.global_position)
	if objsToPush[0] is RigidBody3D:
		var direction = (objsToPush[0].global_position - global_position).normalized()
		mesh_decoy.rotation.y = atan2(-direction.x, -direction.z)
		mesh.rotation.y = atan2(-direction.x, -direction.z)
		sm.is_pushing = true
		await get_tree().create_timer(0.30).timeout
		objsToPush[0].apply_central_impulse(direction* 170000)
		
func jump():
	jumping = true
	sm.jump()
	var direction = Vector3.ZERO
	if is_move_input():
		direction.x = Input.get_action_strength("move_down") * mx - Input.get_action_strength("move_up") * mx - Input.get_action_strength("move_left") * mz + Input.get_action_strength("move_right") * mz 
		direction.z = Input.get_action_strength("move_down") * mz - Input.get_action_strength("move_up") * mz + Input.get_action_strength("move_left") * mx - + Input.get_action_strength("move_right") * mx
		mesh.rotation.y = atan2(-direction.x, -direction.z)
		mesh_decoy.rotation.y = atan2(-direction.x, -direction.z)
	await get_tree().create_timer(0.33).timeout
	if on_floor:
		apply_central_impulse(Vector3(direction.x*6000.0, 13000.0, direction.z*6000.0))
		for obj in floor_detector.get_overlapping_bodies().filter(func(obj): return obj.is_in_group("IsPushedDown")):
			obj.apply_central_impulse(Vector3(direction.x*6000.0, -10000.0, direction.z*6000.0))
	jumping = false
	
func _on_floor_detector(boolean):
	on_floor = boolean

func _on_daytime_changed(text : String, color : Color):
	if ui != null:
		ui.set("custom_colors/font_color", color)
		ui.add_to_queue(text.to_upper(), 2)

func is_move_input():
	if Input.is_action_pressed("move_down") || Input.is_action_pressed("move_up") || Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left"):
		return true
	else:
		return false
