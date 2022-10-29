extends "res://scripts/abstract/StateMachine.gd"

const STATES = {
	'chasing'= 1, 
	'idle'= 2,
	'hit' = 3,
	'attack'= 4
}

@onready var raycast : RayCast3D

signal entered_state (state : String, startSec : float)

@export var stun_time = 0.1
@export var stun_force = 50.0
@export var faster_time = 0.2

var zap_pos = null
var player_pos = null
			
var on_burn = false
var nextAnimDelay = 0.0

var attacking = false :
	set(value):
		if value == true:
			attacking = true
			set_state(STATES.attack)
			await get_tree().create_timer(0.875).timeout
			attacking = false
		else:
			attacking = false

var stunned = false :
	set(value):
		if value == true:
			stunned = true
			set_state(STATES.hit)
			await get_tree().create_timer(stun_time).timeout
			stunned = false
		else:
			stunned = false

func _ready():
	add_states(STATES)
	set_physics_process(true)
	call_deferred("set_state", STATES.idle)
	
	raycast = parent.raycast

func _update_state(delta):
	#print(STATES.find_key(state))
	var parent_velocity = parent.velocity.length()
	match state:
		STATES.idle:
			if player_pos != null:
				return STATES.chasing
		STATES.hit:
			if stunned == true:
				return
			if player_pos != null:
				return STATES.chasing
			else:
				return STATES.idle
		STATES.chasing:
			parent.rotate_towards_motion(delta)
			if player_pos != null:
				parent.navAgent.set_target_location(player_pos)
				parent.move_to_target()
			if player_pos == null:
				return STATES.idle
		STATES.attack:
			if player_pos != null:
				parent.navAgent.set_target_location(player_pos)
				parent.move_to_target()
			if attacking :
				return
			if player_pos != null:
				set_state(STATES.chasing)
			else:
				return STATES.idle

func _enter_state(new_state,_old_state):
	#print(STATES.find_key(new_state))
	emit_signal("entered_state", STATES.find_key(new_state), nextAnimDelay)
	nextAnimDelay = 0.0
	match new_state:
		STATES.idle:
			parent.navAgent.set_target_location(parent.global_transform.origin)
			parent.speed = 0
		STATES.hit:
			parent.health -= 5
			var enemy_location = parent.global_transform.origin
			var light_to_enemy_vector : Vector3 = enemy_location - zap_pos
			var le_size_sqrd = light_to_enemy_vector.length_squared()
			parent.move(stun_time/3, stun_force * light_to_enemy_vector/le_size_sqrd)
		STATES.attack:
			parent.speed = 2
			nextAnimDelay = 0.875
		STATES.chasing:
			parent.speed = 3

func _on_fov_player_location(target):
	#testar a "memoria" do inimigo com o teste da janela
	if raycast == null:
		return
	if target != null:
		raycast.target_position = target - raycast.global_position  
		if raycast.is_colliding() && raycast.get_collider().is_in_group("Player"):
			player_pos = target
		else:
			if parent.navAgent.is_target_reached():
				player_pos = null
	elif parent.navAgent.is_target_reached():
		player_pos = null
