extends Node3D
@onready var animator : AnimationPlayer = get_node("AnimationPlayer")

func _on_sm_entered_state(state, startSec):
	if(animator.has_animation(state)):
		animator.play(state)
		animator.seek(startSec, true)
