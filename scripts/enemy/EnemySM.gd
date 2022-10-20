extends "res://scripts/abstract/StateMachine.gd"

var player_on_range

const STATES = {
	'chasing'= 1, 
	'idle'= 2,
	'running' = 3
}

signal entered_state (state : String)

func _ready():
	add_states(STATES)
	set_physics_process(true)
	call_deferred("set_state", STATES.idle)

func _update_state(delta):
	match state:
		STATES.idle:
			if(player_on_range):
				return STATES.chasing
		STATES.chasing:
			if(!player_on_range):
				return STATES.idle
	pass


func _enter_state(new_state,_old_state):
	emit_signal("entered_state", STATES.find_key(new_state))

func _on_range_area_player_location(target):
	if (target == null):
		player_on_range = false
	else:
		player_on_range = true
