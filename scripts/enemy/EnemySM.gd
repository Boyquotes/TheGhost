extends "res://scripts/abstract/StateMachine.gd"

const STATES = {
	'chasing'= 1, 
	'idle'= 2,
	'hit' = 3
}

signal entered_state (state : String)

@onready var animator : AnimationPlayer = get_node("../Mesh/AnimationPlayer")

@export var stun_time = 0.3

var zap_pos = null
var player_pos = null
var on_burn = false
var is_hit = false

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

func _update_state(delta):
	#print(STATES.find_key(state))
	match state:
		STATES.idle:
			if  player_pos != null:
				return STATES.chasing
		STATES.hit:
			parent.move_to_target() #apply knockback
			if stunned == true:
				return
			if player_pos != null:
				return STATES.chasing
			else:
				return STATES.idle
		STATES.chasing:
			if (player_pos != null): 
				parent.navAgent.set_target_location(player_pos)
				parent.rotate_towards_motion(delta)
				parent.move_to_target()
			if player_pos == null:
				return STATES.idle


func _enter_state(new_state,_old_state):
	emit_signal("entered_state", STATES.find_key(new_state))
	match new_state:
		STATES.idle:
			parent.navAgent.set_target_location(parent.global_transform.origin)
			parent.speed = 1
		STATES.hit:
			parent.health -= 5
			parent.navAgent.set_target_location(1.2 * parent.global_transform.origin - 0.2 * zap_pos)
			parent.speed = 30
		STATES.chasing:
			parent.speed = 5

func _on_fov_player_location(target):
	player_pos = target
