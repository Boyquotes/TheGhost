extends "res://scripts/StateMachine.gd"

const STATES = {
	'idle'= 1, 
	'walking'= 2
}

signal entered_state (state : String)

func _ready():
	add_states(STATES)
	set_physics_process(true)
	call_deferred("set_state",STATES.idle)


func _refresh(delta):
	parent._apply_movement(delta)

func _update_state(delta):
	parent._handle_move_input()
	match state:
		STATES.idle:
			if parent.motion.x != 0 || parent.motion.z != 0 :
				return STATES.walking
		STATES.walking:
			parent._handle_move_rotation(delta)
			if parent.motion.x == 0 && parent.motion.z == 0 :
				return STATES.idle

func _enter_state(new_state,_old_state):
	match new_state:
		STATES.idle:
			emit_signal("entered_state", "idle")
		STATES.walking:
			emit_signal("entered_state", "walking")
			
