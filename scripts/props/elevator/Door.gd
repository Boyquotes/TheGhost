extends MeshInstance3D

var open_animation = false
var close_animation = false
var is_open = false
var locked = false


func _input(event):
	if (Input.is_action_pressed("talk")) and not locked:
		toggle()

func toggle():
	if open_animation || close_animation:
		return
	if is_open:
		close()
	else:
		open()

func open():
	$ColisionClosed/CollisionShape3D.disabled = true
	is_open = true
	open_animation = true

func close():
	$ColisionClosed/CollisionShape3D.disabled = false
	is_open = false
	close_animation = true

func _physics_process(delta):
	if open_animation:
		

	if close_animation:
		var current_open = get_blend_shape_value(0)
		var next_open = lerpf(current_open, -0.1, delta)
		set_blend_shape_value(0, next_open)
		if next_open <= 0.0:
			set_blend_shape_value(0, 0.0)
			close_animation = false
			is_open= false
			
