extends Node3D

@onready var animator : AnimationPlayer = get_node("AnimationPlayer")

func _on_sm_entered_state(state):
	animator.play(state)
