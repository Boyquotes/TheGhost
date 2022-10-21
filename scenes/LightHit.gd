extends Area3D

func _on_area_entered(area):
	if (area.is_in_group("Enemy")):
		area.get_parent().health -= 1 #TODO n é bom mudar essa var aqui na luz, rever isso quando der
