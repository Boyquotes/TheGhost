extends "res://scripts/abstract/StateMachine.gd"

const STATES = {
	'idle'= 1, 
	'walking'= 2,
	'hit'= 3
}

@export var hit_time = 2.0

var is_hit = false:
	set(value):
		if value == true:
			is_hit = true
			set_state(STATES.hit)
			await get_tree().create_timer(hit_time).timeout
			is_block = true
			is_hit = false
		else:
			is_hit = false
			
var is_block = false:
	set(value):
		if value == true:
			is_block = true
			await get_tree().create_timer(0.1).timeout
			is_block = false
		else:
			is_block = false

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
		STATES.hit:
			parent._handle_move_input()
			parent._handle_move_rotation(delta)
			if parent.speed != 0:
				return STATES.walking
			elif parent.speed == 0:
				return STATES.idle
		STATES.walking:
			parent._handle_move_input()
			parent._handle_move_rotation(delta)
			if parent.speed == 0 :
				return STATES.idle


func _enter_state(new_state,_old_state):
	#print(STATES.find_key(state))
	emit_signal("entered_state", STATES.find_key(new_state), 0.0)
