extends Area3D

@onready var smoke : GPUParticles3D = $Smoke

var queue_emission = false

func _physics_process(_delta):
	if queue_emission and not smoke.emitting:
		smoke.emitting = true
		queue_emission = false


func _on_body_shape_entered(_body_rid, _body, _body_shape_index, _local_shape_index):
	smoke.emitting = true
	
