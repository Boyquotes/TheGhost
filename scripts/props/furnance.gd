extends Node3D

@onready var animator : AnimationPlayer = $AnimationPlayer
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action("test1"):
		animator.play("open1")
	if event.is_action("test2"):
		animator.play("close1")
