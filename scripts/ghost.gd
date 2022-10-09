extends Node3D

@onready var animator : AnimationPlayer = get_node("AnimationPlayer")
@export var currentAnimation = "idle"
func _on_sm_entered_state(state):
	currentAnimation = state
	animator.play(currentAnimation)

#TODO review inverse kinematics issue
#fix rotation on walking
#code pushing state
#animate pushing state

#model enemy 1
