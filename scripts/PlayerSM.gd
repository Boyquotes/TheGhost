extends "res://scripts/StateMachine.gd"


const STATES = {
	'idle'= 1, 
	'walking'= 2
}

func _ready():
	add_states(STATES)
	set_state(STATES.idle)


func _physics_process(_delta):
	parent._apply_movement()


func _update_state(_delta):
	match state:
		STATES.idle:
			parent._handle_move_input()
			if parent.motion.x != 0 || parent.motion.z !=0 :
				return STATES.walking

		STATES.walking:
			parent._handle_move_input()
			if parent.motion.x == 0 && parent.motion.z ==0 :
				parent._handle_move_input()
				return STATES.idle
			else:
				return STATES.walking
