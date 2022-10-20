extends Node3D
@onready var animator : AnimationPlayer = get_node("AnimationPlayer")

func _on_sm_entered_state(state):
	print(state)
	if(animator.has_animation(state)):
		animator.play(state)
