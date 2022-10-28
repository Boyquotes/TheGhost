extends Node3D

@onready var animator : AnimationPlayer = $AnimationPlayer

var isOpen = false

func rigidBodyOnDoor(body):
	if body.is_in_group("Moveable") && !isOpen:
		await animator.play("open")
		isOpen = true


func rigidBodyOutDoor(body):
	if isOpen :
		await get_tree().create_timer(2).timeout
		await animator.play("close")
		isOpen=false

func open():
	if !isOpen :
		await animator.play("open")
		isOpen= true
