extends "res://scripts/abstract/StateMachine.gd"

const STATES = {
	'chasing'= 1,
	'idle'= 2,
	'attack'= 3,
	'passing'=4
}

signal entered_state (state : String, startSec : float)

@onready var animator : AnimationPlayer = $Mesh/AnimationPlayer
@onready var label : Label3D = $Label3D

@export var stun_time = 0.5
@export var stun_force = 50.0
var stun_source_pos = null
var speed : float

var attacking = false :
	set(value):
		attacking = value
		if value == true:
			set_state(STATES.attack)
			await get_tree().create_timer(0.875).timeout
			attacking = false

func _ready():
	speed = parent.SPEED
	add_states(STATES)
	call_deferred("set_state", STATES.idle)

func _update_state(_delta):
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
		STATES.passing:
			if not animator.is_playing() or parent.passing != false:
				return STATES.idle

func _enter_state(new_state, _old_state):
	var state_name = STATES.find_key(new_state)
	label.override(state_name)
	if animator.has_animation(state_name):
		animator.play(state_name)
	match new_state:
		STATES.attack:
			parent.speed = speed*0.5
		STATES.chasing:
			parent.speed = speed
		STATES.passing:
			parent.speed = speed * 0.001
			await get_tree().create_timer(0.7).timeout
			parent.needs_to_force_foward = true
			
func passing():
	set_state(STATES.passing)


func _on_head_area_body_entered(body):
	if body.is_in_group("HeadBlock"):
		parent.passing = true
		set_state(STATES.passing)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "passing":
		set_state(STATES.idle)
