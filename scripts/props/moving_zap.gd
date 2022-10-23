extends Node3D


@onready 
var light : OmniLight3D = $Light

@onready 
var effects = $Effects

@onready 
var body = get_parent().get_node("RigidBody3D")

@onready 
var light_hit_colision : CollisionShape3D = $LightHit/CollisionShape3D

var light_reduce_ammount
var beam_on_cd = false

@export var health : int = 10 : 
	set(value):
		health = value
		if (health <= 0):
			get_parent().remove_child(self)

func _ready():
	light_reduce_ammount = light.omni_range/10.0

func _physics_process(_delta):
	global_transform.origin = body.global_transform.origin


func _on_light_hit_area_entered(area):
	if (health < 1 || beam_on_cd):
		return
	
	if (area.is_in_group("Enemy")):
		
		beam_on_cd = true
		
		look_at(area.get_parent().global_position+Vector3(0,5,0))
		effects.visible = true
		
		scale -= Vector3(0.1,0.1,0.1)
		light.omni_range -= light_reduce_ammount
		
		area.get_parent().health -= 4

		await get_tree().create_timer(0.25).timeout
		
		health -=1
		effects.visible = false
		beam_on_cd = false
