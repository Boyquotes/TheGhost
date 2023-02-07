extends AudioStreamPlayer3D

var needs_to_play = false

func _physics_process(delta):
	if needs_to_play:
		if !playing:
			play(randf_range(0.0,5.0))
	else:
		stop()


func _on_sm_entered_state(state, starSec):
	#print(state)
	if state in ["walking"] :
		if !playing:
			needs_to_play = true
	else:
		needs_to_play = false
