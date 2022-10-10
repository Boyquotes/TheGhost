extends Node3D

@onready var animator : AnimationPlayer = get_node("AnimationPlayer")
@export var material : Material
@onready var mesh : MeshInstance3D = get_node("Armature/Skeleton3D/Cube")

func _on_sm_entered_state(state):
	animator.play(state)

func _ready():
	if(material):
		mesh.set_surface_override_material(0, material)
