extends Area3D

func _ready():
	collision_mask = Globals.PLAYER_PHYSICAL_BODY_LAYER

signal player(player)

func _physics_process(_delta):
	var player_area = get_overlapping_areas()\
		.filter(func(obj): return obj.is_in_group("Player"))
	
	if(player_area):
		emit_signal("player", player_area[0].location)
