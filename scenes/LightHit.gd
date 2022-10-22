extends Area3D

func _on_area_entered(area):
	if (area.is_in_group("Enemy")):
		get_parent().look_at(area.get_parent().global_position)
		area.get_parent().health -= 4
		$Effects.visible = true
		await get_tree().create_timer(0.25).timeout
		$Effects.visible = false


