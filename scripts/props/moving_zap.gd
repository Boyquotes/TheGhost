extends Node3D


@onready 
var light : OmniLight3D = $Light

@onready 
var effects = $Effects

@onready
var fluid_sparkles : GPUParticles3D = $FluidSparkles

@onready 
var body = get_parent().get_node("RigidBody3D")

@onready 
var light_hit_colision : CollisionShape3D = $LightHit/CollisionShape3D

var light_reduce_ammount
var sparkle_reduce_ammount
var beam_on_cd = false

@export var health : int = 10 : 
	set(value):
		health = value
		if (health <= 0):
			get_parent().remove_child(self)

func _ready():
	light_reduce_ammount = light.omni_range/10.0
	sparkle_reduce_ammount = fluid_sparkles.amount/10

func _physics_process(_delta):
	global_transform.origin = body.global_transform.origin

func _on_light_hit_enemy(obj):
	if (health < 1 || beam_on_cd):
		return
	if (obj != null):
		obj.stun(global_transform.origin)
		
		beam_on_cd = true
		
		look_at(obj.global_position+Vector3(0,2,0))
		effects.visible = true
		light.light_energy = 3

		await get_tree().create_timer(0.3).timeout
		
		effects.visible = false
		light.light_energy = 1
		scale -= Vector3(0.1,0.1,0.1)
		light.omni_range -= light_reduce_ammount
		fluid_sparkles.amount -= sparkle_reduce_ammount
		
		await get_tree().create_timer(1.7).timeout
		
		light.light_energy = 2
		
		health -=1
		effects.visible = false
		beam_on_cd = false
