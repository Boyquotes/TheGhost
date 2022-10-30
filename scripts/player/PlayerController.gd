extends CharacterBody3D

@export var SPEED : int = 5
@export var ROTATION_SPEED : int = 10

var is_pushing = false :
	set(value):
		if sm.is_hit || sm.is_pushing :
			return
		if value == true:
			is_pushing = true
			sm.is_pushing = true
		else:
			is_pushing =false


var speed : float = SPEED 
var motion : Vector3 = Vector3()
var health = 10 :
	set(value):
		if (value < 0):
			value = 0
		health = value
		sm.health = value

var mx = 1.0
var mz = 0.0

@onready var sm = $SM
@onready var mesh_decoy = $RigidBody3D/MeshDecoy
@onready var mesh_decoy_location = $RigidBody3D/MeshDecoy/Armature/Skeleton3D/PhysicalBoneRoot/BodyLocation
@onready var mesh = $RigidBody3D/Mesh
@onready var pushArea : Area3D = $RigidBody3D/Mesh/Push

signal motion_direction (direction : Vector3)

func _apply_movement(_delta):
	velocity = Vector3(motion.x, 0, motion.z)
	move_and_slide()

func _handle_move_input():
	speed = 0
	motion = motion.normalized()
	if Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left") || Input.is_action_pressed("move_down") || Input.is_action_pressed("move_up"):
		motion.x = Input.get_action_strength("move_down") * mx - Input.get_action_strength("move_up") * mx - Input.get_action_strength("move_left") * mz + Input.get_action_strength("move_right") * mz 
		motion.z = Input.get_action_strength("move_down") * mz - Input.get_action_strength("move_up") * mz + Input.get_action_strength("move_left") * mx - + Input.get_action_strength("move_right") * mx
		speed = motion.normalized().length() * SPEED
		
	motion = motion.normalized() * speed

func _input(event):
	if event.is_action_pressed("push"):
		is_pushing = true

func _handle_move_rotation(delta):
	if !sm.is_hit :
		mesh_decoy.rotation.y = lerp_angle(mesh_decoy.rotation.y, atan2(-motion.x, -motion.z), delta * ROTATION_SPEED)
	mesh.rotation.y = lerp_angle(mesh.rotation.y, atan2(-motion.x, -motion.z), delta * ROTATION_SPEED)

func rotate_now():
	if !sm.is_hit :
		mesh_decoy.rotation.y = atan2(-motion.x, -motion.z)
	mesh.rotation.y = atan2(-motion.x, -motion.z)


func _on_camera_node_cam_rotation(rot):
	mx = sin(rot)
	mz = cos(rot)

func hit(vector):
	sm.is_hit = true
	mesh_decoy.hit()

func get_location():
	if sm.is_block == false:
		return mesh_decoy_location.global_position
	else:
		return null

func get_moveables(obj : RigidBody3D):
	return obj.is_in_group("Moveable")
	
func push():
	print("push")
	var objsToPush = pushArea.get_overlapping_bodies().filter(get_moveables)
	for obj in objsToPush:
		print(obj)
		if obj is RigidBody3D:
			obj.apply_central_force(motion * 10000)
	
