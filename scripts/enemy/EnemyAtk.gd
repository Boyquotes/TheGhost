extends Area3D

@onready var sm : StateMachine = get_parent().get_parent().get_node("EnemySM")
@onready var real_hit_box : Area3D = $RealHitBox

var on_cd = false:
	set(value):
		on_cd = value
		if value == true :
			await get_tree().create_timer(3.5).timeout
			on_cd = false
			

func _physics_process(_delta):
	var area = get_overlapping_areas().filter(remove_not_player)
	if area.is_empty():
		return
	if not area[0].monitorable:
		return
	if !sm.attacking && !on_cd:
		area = area[0]
		sm.attacking = true
		await get_tree().create_timer(0.5).timeout #hit frame of animation
		on_cd = true
		var hitboxes_hits = real_hit_box.get_overlapping_areas().filter(remove_not_player)
		if hitboxes_hits:
			area.hit()

func remove_not_player(obj : Node3D):
	return obj.is_in_group("Player")
