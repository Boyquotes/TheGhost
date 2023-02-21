extends Area3D

@onready var smoke : GPUParticles3D = $Smoke

var queue_emission = false

func _physics_process(delta):
	if queue_emission and not smoke.emitting:
		smoke.emitting = true
		queue_emission = false


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	smoke.emitting = true # Replace with function body.
