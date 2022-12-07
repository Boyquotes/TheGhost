extends OmniLight3D

var play_blink = false
var start = false

func blink():
	light_energy = 0.0
	play_blink = true
	start = true

func _physics_process(delta):
	if play_blink:
		if start:
			light_energy = lerpf(light_energy, 1.1, delta * 18.0)
			if (light_energy >= 1.0):
				start=false
			return
	if light_energy > 0:
			light_energy = lerpf(light_energy, 0.1, delta * 6.0)
	if light_energy <= 0:
			play_blink = false
