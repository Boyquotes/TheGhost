extends Node3D
@onready var animator : AnimationPlayer = get_node("AnimationPlayer")
@onready var body_pos = $Armature/Skeleton3D/PhysicalBoneRoot

signal player_body_pos (pos : Vector3, delta : float)

var is_hit = true :
	set(value):
		if value == true:
			is_hit = true
			$Armature/Skeleton3D.physical_bones_start_simulation()
			await get_tree().create_timer(2).timeout
			$Armature/Skeleton3D.physical_bones_stop_simulation()
			is_hit = false
		else:
			is_hit = false
	
func _on_sm_entered_state(state, startSec):
	if(animator.has_animation(state)):
		animator.play(state)
		animator.seek(startSec, true)

func hit() -> void:
	is_hit = true
