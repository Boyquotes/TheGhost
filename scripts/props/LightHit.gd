extends Area3D
#kkkkkkkkkk
@onready var health = get_parent().get_parent().health

func _on_area_entered(area):
	if (area.is_in_group("Enemy") && health>0):
		get_parent().look_at(area.get_parent().global_position+Vector3(0,5,0))
		area.get_parent().health -= 4
		$Effects.visible = true
		await get_tree().create_timer(0.25).timeout
		$Effects.visible = false


