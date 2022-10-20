extends Node3D

@onready var animator : AnimationPlayer = get_node("AnimationPlayer")
@onready var veil : MeshInstance3D = get_node("Armature/Skeleton3D/Veil")
@onready var glove : MeshInstance3D = get_node("Armature/Skeleton3D/Gloves")
@onready var veilMaterial : BaseMaterial3D = preload("res://materials/veilMaterial.tres")
@onready var gloveMaterial : BaseMaterial3D = preload("res://materials/veilMaterial.tres")

func _on_sm_entered_state(state):
	animator.play(state)

func _ready():
	veil.material_override = veilMaterial
	glove.material_override = gloveMaterial
