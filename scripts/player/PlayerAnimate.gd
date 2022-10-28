extends Node3D
@onready var animator : AnimationPlayer = get_node("AnimationPlayer")

signal player_body_pos (pos : Vector3, delta : float)

func _physics_process(delta):
	emit_signal("player_body_pos", global_position, delta)
	
func _on_sm_entered_state(state, startSec):
	if(animator.has_animation(state)):
		animator.play(state)
		animator.seek(startSec, true)

func hit() -> void:
	$Armature/Skeleton3D.physical_bones_start_simulation()
	await get_tree().create_timer(2).timeout
	$Armature/Skeleton3D.physical_bones_stop_simulation()
