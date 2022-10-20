extends "res://scripts/abstract/StateMachine.gd"

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

func _update_state(_delta):
	match state:
		STATES.idle:
			if(parent.velocity.length() > 1):
				return STATES.chasing
		STATES.chasing:
			if(parent.velocity.length() < 1):
				return STATES.idle
	pass


func _enter_state(new_state,_old_state):
	emit_signal("entered_state", STATES.find_key(new_state))
