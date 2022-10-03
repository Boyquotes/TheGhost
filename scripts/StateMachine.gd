extends Node
class_name StateMachine

var state = null
var previous_state = null
var states = {}

@onready var parent = get_parent()

func _ready():
	set_physics_process(true)


func _physics_process(delta):
	if state != null:
		_refresh(delta)
		var transition = _update_state(delta)
		if transition != null:
			set_state(transition)

func _refresh(_delta):
	pass

func _update_state(_delta):
	return null

func _enter_state(_new_state,_old_state):
	pass

func _exit_state(_old_state,_new_state):
	pass

func set_state(new_state):
	previous_state = state
	state = new_state
	if previous_state != null:
		_exit_state(previous_state, new_state)
	if new_state != null :
		_enter_state(new_state,previous_state)

func add_states(states):
	for state in states:
		states[state] = states.size()
