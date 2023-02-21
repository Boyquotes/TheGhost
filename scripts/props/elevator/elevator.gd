extends Node3D

@onready var door = $StaticBody3D/Door

@export var target_height : float
var original_height : float

func _ready():
	original_height = global_position.y


func _physics_process(delta):
	if abs(target_height - global_position.y) <= 1.1:
		global_position.y = target_height
		#door.locked = false
		door.open()
	if !door.is_open:
		door.locked = true
		#global_position.y = lerpf(global_position.y, target_height,  0.001)
