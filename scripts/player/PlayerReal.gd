extends Node3D
@onready var animator : AnimationPlayer = get_node("AnimationPlayer")

signal player_real_pos (pos : Vector3, delta : float)

func _physics_process(delta):
	emit_signal("player_real_pos", global_position, delta)
	
func _on_sm_entered_state(state, startSec):
	if state == "hit":
		visible = true
		animator.play("walking")
		animator.seek(startSec, true)
		await get_tree().create_timer(2.0).timeout
		visible = false
		
