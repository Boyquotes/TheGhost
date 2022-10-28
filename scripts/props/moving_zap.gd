extends Node3D

@onready var raycast : RayCast3D = $RayCast3D
@onready var light : OmniLight3D = $Light
@onready var effects = $Effects
@onready
var effects_particles : GPUParticles3D = $Effects/EffectsParticles
@onready
var fluid_sparkles : GPUParticles3D = $FluidSparkles
@onready
var body = get_parent().get_node("RigidBody3D")
@onready 
var light_hit_colision : CollisionShape3D = $LightHit/CollisionShape3D

var light_reduce_ammount : float
var sparkle_reduce_ammount : int
var beam_on_cd : bool = false

@export var cd : float = 1.7

@export var health : int = 10 : 
	set(value):
		health = value
		if (health <= 0 && get_parent() != null):
			get_parent().remove_child(self)

func _ready():
	effects.visible = false
	light_reduce_ammount = light.omni_range/10.0
	sparkle_reduce_ammount = fluid_sparkles.amount/10

func _physics_process(_delta):
	global_transform.origin = body.global_transform.origin

func _on_light_hit_enemy(obj):
	if (health < 1 || beam_on_cd):
		return
	if (obj != null):
		raycast.target_position = obj.global_position - raycast.global_position
		if !raycast.is_colliding():
			return
		if !raycast.get_collider().is_in_group("Enemy"):
			return
		
		effects.look_at(obj.global_position+Vector3(0,2,0))
		obj.stun(global_transform.origin)
		beam_on_cd = true
		effects.visible = true
		effects_particles.emitting = true
		light.light_energy = 10

		await get_tree().create_timer(0.3).timeout
		
		effects.visible = false
		light.light_energy = 1
		scale -= Vector3(0.1,0.1,0.1)
		light.omni_range -= light_reduce_ammount
		if fluid_sparkles.amount - sparkle_reduce_ammount > 0:
			fluid_sparkles.amount -= sparkle_reduce_ammount
		
		await get_tree().create_timer(cd).timeout
		
		light.light_energy = 5
		
		health -=1
		effects.visible = false
		beam_on_cd = false

func getFuel():
	var fuel = health
	health = 0
	return fuel
