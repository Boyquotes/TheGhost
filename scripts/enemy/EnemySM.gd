extends "res://scripts/abstract/StateMachine.gd"

const STATES = {
	'chasing'= 1, 
	'idle'= 2,
	'hit' = 3
}

var zap_pos = null
var player_pos = null
var on_burn = false

signal entered_state (state : String)

func _ready():
	add_states(STATES)
	set_physics_process(true)
	call_deferred("set_state", STATES.idle)

func _update_state(delta):
	#print(STATES.find_key(state))
	match state:
		STATES.idle:
			#parent.navAgent.set_target_location(parent.global_transform.origin)
			if zap_pos != null:
				return STATES.hit
			elif  player_pos != null:
				return STATES.chasing
			return STATES.idle
		STATES.hit:
			if (zap_pos != null): 
				parent.navAgent.set_target_location(2 * parent.global_transform.origin - zap_pos)
			parent.move_to_target()
			await get_tree().create_timer(0.5).timeout
			if zap_pos != null:
				return STATES.hit
			elif player_pos != null:
				return STATES.chasing
			return STATES.idle
		STATES.chasing:
			if (player_pos != null): 
				parent.navAgent.set_target_location(player_pos)
				parent.rotate_towards_motion(delta)
			parent.move_to_target()
			if zap_pos != null:
				return STATES.hit
			if player_pos != null:
				return STATES.chasing
			else: 
				return STATES.idle
	pass


func _enter_state(new_state,_old_state):
	match new_state:
		STATES.idle:
			parent.speed = 1
		STATES.hit:
			parent.speed = 20
		STATES.chasing:
			parent.speed = 5
	emit_signal("entered_state", STATES.find_key(new_state))


func _on_fov_player_location(target):
	player_pos = target

func _on_range_zap(position):
	zap_pos = position
