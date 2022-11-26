extends Node3D

@onready var frontDoor = $Doors/Door3
@onready var chimney : CPUParticles3D = $Effects/Smoke
@onready var chimneyLight : OmniLight3D = $Effects/OmniLight3D

var chimney_smoke_speed : float

var content_on_consumer : bool = false

func _ready():
	chimney_smoke_speed = chimney.speed_scale

func rigidBodyOnConsumer(body : RigidBody3D):
	content_on_consumer = true
	body.freeze = true
	body.global_position = global_position - Vector3(0,3.0,0)
	var fuel = body.get_parent().getFuel()
	if fuel == null:
		return
	if fuel[0] > 0 :
		chimney.speed_scale = chimney_smoke_speed * 4.0
		chimneyLight.light_energy= 24.0
		chimneyLight.light_volumetric_fog_energy = 8

	await get_tree().create_timer(2).timeout
	chimneyLight.light_energy = 16.0
	chimney.speed_scale = chimney_smoke_speed
	chimneyLight.light_volumetric_fog_energy = 1
	body.freeze = false
	frontDoor.open()
	await get_tree().create_timer(0.7).timeout
	body.apply_central_impulse(Vector3(0,0,100000))


func rigidBodyOutConsumer(body):
	pass # Replace with function body.
