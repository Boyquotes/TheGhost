extends RigidBody3D
@export var MAX_SPEED : float = 4.5
@export var SPEED : float = 1000.0
@export var ROTATION_SPEED : int = 8

var INITIAL_MASS = mass

const MAX_STAMINA = 3

var INITIAL_POSITION = Vector3()

var checkpoint = null :
	set(value):
		checkpoint = value
		INITIAL_POSITION = checkpoint.global_position

var jumping = false

var spam_timer

var spam = false:
	set(value):
		spam = value
		if value:
			spam_timer = get_tree().create_timer(0.75)
			await spam_timer.timeout
			spam = false

signal current_stamina (value : int)

var stamina = MAX_STAMINA:
	set(value):
		stamina = value
		emit_signal("current_stamina", stamina)
		if value > 0:
			player_light.light_energy = 2
		if stamina <= 1:
			player_light.light_energy = 0
			stamina_timer.start(9)
			return
		elif value < MAX_STAMINA:
			stamina_timer.start(2)

var stamina_display = stamina

var dashing = false :
	set(value):
		if value:
			dashing_effects.emitting = true
		else:
			dashing_effects.emitting = false
		if dashing && !value:
			dashing_stop.emitting = true
		dashing = value

var on_floor = true :
	set(value):
		if !on_floor and value:
			landing_effects.emitting = true
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

var can_push = true

@onready var walking_effects = get_tree().get_first_node_in_group("WalkEffects")
@onready var dashing_stop = get_tree().get_first_node_in_group("DashEffectsStop")
@onready var dashing_effects = get_tree().get_first_node_in_group("DashEffects")
@onready var landing_effects = get_tree().get_first_node_in_group("LandEffects")
@onready var hit_effects = get_tree().get_first_node_in_group("HitEffects")
@onready var sm = $SM
@onready var mesh_decoy = $MeshDecoy
@onready var mesh_decoy_location = $"MeshDecoy/Armature/Skeleton3D/Physical Bone Root/BodyLocation"
@onready var pushArea : Area3D = $MeshDecoy/Push
@onready var ui : Label = $VBoxContainer/Label
@onready var player_text : Label3D = $MeshDecoy/Label3D
@onready var floor_detector : Area3D = $FloorDetector
@onready var hitSound : AudioStreamPlayer3D = get_tree().get_first_node_in_group("HitSound")
@onready var stamina_timer : Timer = $StaminaTimer
@onready var player_light : OmniLight3D = get_tree().get_first_node_in_group("PlayerLight")

var inform_death = []

signal player_spawn (pos : Vector3)

func _ready():
	INITIAL_POSITION = get_parent().global_position
	inform_death = get_tree().get_root().get_tree().get_nodes_in_group("NeedsToReset")
	stamina = MAX_STAMINA

func dec_stamina():
	stamina -= 1

func _apply_movement():
	if on_floor && linear_velocity.length() < MAX_SPEED && is_move_input():
		if stamina == 0:
			motion = motion * 0.3
		walking_effects.emitting = true
		apply_central_impulse(Vector3(motion.x, 333.3, motion.z))
	else:
		walking_effects.emitting = false
	
func _handle_move_input():
	speed = 0
	if !is_move_input():
		return
	motion.x = Input.get_action_strength("move_down") * mx - Input.get_action_strength("move_up") * mx - Input.get_action_strength("move_left") * mz + Input.get_action_strength("move_right") * mz 
	motion.z = Input.get_action_strength("move_down") * mz - Input.get_action_strength("move_up") * mz + Input.get_action_strength("move_left") * mx - + Input.get_action_strength("move_right") * mx
	speed = motion.normalized().length() * SPEED
	motion = motion.normalized() * speed

func  _physics_process(_delta):
	if dashing or not on_floor:
		stamina_timer.paused = true
	else:
		stamina_timer.paused = false
	if stamina < MAX_STAMINA:
		var cs = (stamina_timer.time_left - stamina_timer.wait_time) / - stamina_timer.wait_time
		stamina += cs
	else:
		stamina_display = MAX_STAMINA
	#player_text.override(str("current stamina ", str(stamina).pad_decimals(2) ))

func _input(event):
	if event.is_action_pressed("push") && sm.state in [1,2,7] && !jumping:
		push()
	if event.is_action_pressed("jump") && !sm.is_hit && sm.state in [1,2,7] && !jumping:
		jump()
	if event.is_action_pressed("dash") && !sm.is_hit && sm.state in [2] && !jumping && not spam:
		spam = true
		dash()


func _handle_move_rotation(delta):
	if motion.length() < 10 || jumping || dashing || !is_move_input():
		return
	if !sm.is_hit :
		mesh_decoy.rotation.y = lerp_angle(mesh_decoy.rotation.y, atan2(-motion.x, -motion.z), delta * ROTATION_SPEED)

func _on_camera_node_cam_rotation(rot):
	mx = sin(rot)
	mz = cos(rot)

func hit():
	if dashing:
		return
	hitSound.play(0.0)
	hit_effects.emitting = true
	sm.is_hit = true
	mesh_decoy.hit()
	Engine.time_scale = 0.3
	await get_tree().create_timer(0.2).timeout
	Engine.time_scale = 1.0

func ik():
	reset()

func reset():
	if checkpoint != null:
		INITIAL_POSITION = checkpoint.global_position
	dashing = false
	can_push = true
	sm.set_state(5)
	emit_signal("player_spawn", INITIAL_POSITION)
	global_position = INITIAL_POSITION
	for element in inform_death:
		element.player_death()

func get_location():
	if sm.is_block == false:
		return mesh_decoy_location.global_position
	else:
		return null

func push():
	if stamina <= 0:
		return
	if can_push:
		if sm.is_hit || sm.is_pushing:
			return
		var objsToPush = pushArea.get_overlapping_bodies().filter(func(obj): return obj.is_in_group("Moveable"))
		if objsToPush.is_empty():
			return
		objsToPush.sort_custom(func(a, b): return global_position - a.global_position < global_position - b.global_position)
		var direction = (objsToPush[0].global_position - global_position).normalized()
		mesh_decoy.rotation.y = atan2(-direction.x, -direction.z)
		can_push = false
		sm.is_pushing = true
		await get_tree().create_timer(0.30).timeout
		if objsToPush[0] is RigidBody3D:
			dec_stamina()
			objsToPush[0].apply_central_impulse(direction* objsToPush[0].mass * 20)
		else:
			objsToPush[0].push()
		if objsToPush[0].is_in_group("Checkpoint"):
			checkpoint = objsToPush[0].checkpoint
		await get_tree().create_timer(1).timeout
		can_push = true
	
func jump():
	if stamina <= 0:
		return
	jumping = true
	sm.jump()
	var direction = Vector3.ZERO
	if is_move_input():
		direction.x = Input.get_action_strength("move_down") * mx - Input.get_action_strength("move_up") * mx - Input.get_action_strength("move_left") * mz + Input.get_action_strength("move_right") * mz 
		direction.z = Input.get_action_strength("move_down") * mz - Input.get_action_strength("move_up") * mz + Input.get_action_strength("move_left") * mx - + Input.get_action_strength("move_right") * mx
		mesh_decoy.rotation.y = atan2(-direction.x, -direction.z)
	await get_tree().create_timer(0.33).timeout
	if on_floor:
		direction = direction.normalized()
		dec_stamina()
		apply_central_impulse(Vector3(direction.x*6500.0, 15000.0, direction.z*6500.0))
		for obj in floor_detector.get_overlapping_bodies().filter(func(obj): return obj.is_in_group("IsPushedDown")):
			obj.apply_central_impulse(Vector3(direction.x*6000.0, -10000.0, direction.z*6000.0))
	jumping = false

func dash():
	if stamina <= 0:
		return
	if dashing:
		return
	if sm.state != 2:
		return
	dashing = true
	var direction = Vector3.ZERO
	sm.dash()
	if is_move_input():
		direction.x = Input.get_action_strength("move_down") * mx - Input.get_action_strength("move_up") * mx - Input.get_action_strength("move_left") * mz + Input.get_action_strength("move_right") * mz 
		direction.z = Input.get_action_strength("move_down") * mz - Input.get_action_strength("move_up") * mz + Input.get_action_strength("move_left") * mx - + Input.get_action_strength("move_right") * mx
		mesh_decoy.rotation.y = atan2(-direction.x, -direction.z)
	SPEED = 0
	await get_tree().create_timer(0.1726).timeout
	if on_floor:
		direction = direction.normalized()
		dec_stamina()
		apply_central_impulse(Vector3(direction.x*20000.0, 800.0, direction.z*20000.0))
	
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
