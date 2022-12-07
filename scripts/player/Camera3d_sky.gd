extends Camera3D

@onready var env : Environment = load("res://materials/player/env.tres")

const morning = Color("#afe7ed")

const STATES = {
	'morning'= Color("#afe7ed"), 
	'midday'= Color("#FFCCBE"),
	'afternoon'= Color("#9c646a"),
	'midnight'= Color("#153030")
}

var begin_blend: bool = false
var next_color : Color :
	set(value):
		emit_signal("daytime", STATES.find_key(value), value)
		next_color = value
var next_light : float = 1.0

signal daytime (text : String, color : Color)

func _ready():
	environment = env
	environment.background_color = STATES.morning
	await get_tree().create_timer(1).timeout
	cycle()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	var delta_color = environment.background_color
	environment.background_color = Color(
		lerpf(delta_color.r, next_color.r, 0.15*3 * delta), 
		lerpf(delta_color.g, next_color.g, 0.15*3 * delta), 
		lerpf(delta_color.b, next_color.b, 0.15*3 * delta))
	environment.background_energy_multiplier = lerpf(
		environment.background_energy_multiplier, next_light, 0.15 * delta)
	
func cycle():
	next_light = 1.0
	next_color = STATES.midnight
	await get_tree().create_timer(20*3).timeout
	next_color = STATES.morning
	next_light = 1.1
	await get_tree().create_timer(7*3).timeout
	next_color = STATES.midday
	next_light = 2.5
	await get_tree().create_timer(10*3).timeout
	next_color = STATES.afternoon
	next_light = 1.0
	await get_tree().create_timer(3*3).timeout
	cycle()