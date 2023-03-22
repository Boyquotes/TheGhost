extends "res://scripts/abstract/StateMachine.gd"

const STATES = {
	'walking'=1,
	'walking_grab'=2,
	'grab'=3,
	'idle'=4
}

signal entered_state (state : String, startSec : float)

@onready var animator : AnimationPlayer = $AnimationPlayer
@onready var label : Label3D = $Label3D
@onready var walking_particles : GPUParticles3D = $WalkingEffect

func _ready():
	add_states(STATES)
	call_deferred("set_state", STATES.idle)

func _update_state(_delta):
	label.override(str("should_rest ", parent.should_rest, "|rest ", parent.rest))
	match state:
		STATES.walking:
			if parent.rest:
				return STATES.idle
			if parent.grabbed:
				return STATES.grab
		STATES.walking_grab:
			if parent.rest:
				return STATES.idle
			if not parent.grabbed:
				return STATES.walking
		STATES.idle:
			if not parent.rest:
				return STATES.walking

func _enter_state(new_state, _old_state):
	var state_name = STATES.find_key(new_state)
	if animator.has_animation(state_name):
		animator.play(state_name)
	match new_state:
		STATES.walking or STATES.walking_grab:
			walking_particles.emitting = true
		STATES.idle:
			walking_particles.emitting = false


func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'grab':
		set_state(STATES.walking_grab)
