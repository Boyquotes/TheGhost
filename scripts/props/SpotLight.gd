extends Node3D

@onready var lamp_head = $Head
@onready var area_detector = $Area3D


func _ready():
	area_detector.collision_mask = Globals.PLAYER_PHYSICAL_BODY_LAYER

signal player(player)

func _physics_process(_delta):
	if area_detector.monitoring:
		var player_area = area_detector.get_overlapping_areas()\
			.filter(func(obj): return obj.is_in_group("Player"))
		if (!player_area.is_empty() and player_area[0].location != null):
			lamp_head.look_at(player_area[0].location)
