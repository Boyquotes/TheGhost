extends "res://scripts/abstract/StateMachine.gd"

const STATES = {
	'idle'= 1, 
	'walking'= 2,
	'hit'= 3,
	'push'= 4,
	'falling' = 5
}

@onready var attractor = get_tree().get_first_node_in_group("Attractor")

@export var hit_time = 2.0

var on_floor:
	set(value):
		if on_floor != value && value == false:
			set_state(STATES.falling)
		on_floor = value

var SPEED

var is_pushing = false:
	set(value):
		is_pushing = value
		if value:
			set_state(STATES.push)
			await get_tree().create_timer(0.30).timeout
			parent.push()
			await get_tree().create_timer(0.37).timeout
			set_state(STATES.idle)
			is_pushing=false
			parent.is_pushing=false

var health = 10 :
	set(value):
		health = value
		if health < 10 :
			attractor.visible = true
		if health == 10 :
			attractor.visible = false

var is_hit = false:
	set(value):
		is_hit = value
		if value:
			set_state(STATES.hit)
			await get_tree().create_timer(hit_time).timeout
			is_block = true
			is_hit = false
			
var is_block = false:
	set(value):
		is_block = value
		if value:
			is_block = true
			await get_tree().create_timer(0.1).timeout
			is_block = false

signal entered_state (state : String, starSec : float)

func _ready():
	SPEED = parent.SPEED
	add_states(STATES)
	set_physics_process(true)
	call_deferred("set_state",STATES.falling)

func _update_state(delta):
	#print(STATES.find_key(state))
	match state:
		STATES.idle:
			parent._handle_move_input()
			if parent.speed != 0 :
				return STATES.walking
		STATES.hit:
			parent._handle_move_input()
			parent._handle_move_rotation(delta)
			parent._apply_movement()
			if parent.speed != 0:
				return STATES.walking
			elif parent.speed == 0:
				return STATES.idle
		STATES.walking:
			parent._handle_move_input()
			parent._handle_move_rotation(delta)
			parent._apply_movement()
			if parent.speed == 0 :
				return STATES.idle
		STATES.falling:
			if is_hit:
				return STATES.hit
			if on_floor == true:
				return STATES.walking


func _enter_state(new_state,old_state):
	match new_state:
		STATES.hit:
			parent.SPEED = SPEED
			health -= 3
		STATES.idle:
			parent.SPEED = SPEED
		STATES.walking:
			parent.SPEED = SPEED
		STATES.push:
			parent.SPEED = 0
		
	emit_signal("entered_state", STATES.find_key(new_state), 0.0)
