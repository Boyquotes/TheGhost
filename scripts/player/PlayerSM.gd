extends "res://scripts/abstract/StateMachine.gd"

const STATES = {
	'idle'= 1, 
	'walking'= 2
}

signal entered_state (state : String, starSec : float)

func _ready():
	add_states(STATES)
	set_physics_process(true)
	call_deferred("set_state",STATES.idle)

func _update_state(delta):
	#print(STATES.find_key(state))
	parent._apply_movement(delta)
	match state:
		STATES.idle:
			parent._handle_move_input()
			if parent.speed != 0 :
				return STATES.walking
		STATES.walking:
			parent._handle_move_input()
			parent._handle_move_rotation(delta)
			if parent.speed == 0 :
				return STATES.idle


func _enter_state(new_state,_old_state):
	emit_signal("entered_state", STATES.find_key(new_state), 0.0)
