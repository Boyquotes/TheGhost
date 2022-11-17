extends "res://scripts/abstract/StateMachine.gd"

const STATES = {
	'chasing'= 1,
	'idle'= 2,
	'hit' = 3,
	'attack'= 4
}

signal entered_state (state : String, startSec : float)

@onready var animator : AnimationPlayer = get_node("AnimationPlayer")

@export var stun_time = 0.5
@export var stun_force = 50.0
var stun_source_pos = null
var speed = 5.0

var attacking = false :
	set(value):
		attacking = value
		if value == true:
			set_state(STATES.attack)
			await get_tree().create_timer(0.875).timeout
			attacking = false


var stunned = false :
	set(value):
		stunned = value
		if value == true:
			set_state(STATES.hit)
			await get_tree().create_timer(stun_time).timeout
			stunned = false


func _ready():
	add_states(STATES)
	call_deferred("set_state", STATES.idle)

func _update_state(delta):
	match state:
		STATES.idle:
			if parent.has_target:
				return STATES.chasing
		STATES.chasing:
			if !parent.has_target:
				return STATES.idle
		STATES.attack:
			if attacking :
				return
			if parent.has_target:
				return STATES.chasing
			else:
				return STATES.idle
		STATES.hit:
			if stunned == true:
				return
			if parent.has_target:
				return STATES.chasing
			else:
				return STATES.idle

func _enter_state(new_state, old_state):
	var state_name = STATES.find_key(new_state)
	if animator.has_animation(state_name):
		animator.play(state_name)
	
	match new_state:
		STATES.hit:
			parent.health -= 5
			var enemy_location = parent.global_transform.origin
			var light_to_enemy_vector : Vector3 = enemy_location - stun_source_pos
			var le_size_sqrd = light_to_enemy_vector.length_squared()
			parent.move(stun_time/2, stun_force * light_to_enemy_vector/le_size_sqrd)
		STATES.chasing:
			parent.speed = speed
		STATES.attack:
			parent.speed = speed/3.0
