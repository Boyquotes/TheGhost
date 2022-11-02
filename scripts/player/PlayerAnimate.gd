extends Node3D
@onready var animator : AnimationPlayer = get_node("AnimationPlayer")
@onready var animator2 = $AnimationPlayer2

var is_hit = true :
	set(value):
		if value == true:
			is_hit = true
			$Armature/Skeleton3D.physical_bones_start_simulation()
			animator2.play("Despawn")
			await get_tree().create_timer(2).timeout
			$Armature/Skeleton3D.physical_bones_stop_simulation()
			animator2.play("Spawn")
			is_hit = false
		else:
			is_hit = false
	
func _on_sm_entered_state(state, startSec):
	print("playing " + state)
	if(animator.has_animation(state)):
		animator.play(state)
		animator.seek(startSec, true)

func hit() -> void:
	is_hit = true
