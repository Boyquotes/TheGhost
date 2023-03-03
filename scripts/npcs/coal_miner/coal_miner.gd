extends Node3D

@onready var animator : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("Walking")
