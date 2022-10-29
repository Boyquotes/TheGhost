extends Area3D

@onready var controller = get_tree().get_first_node_in_group("Controller")
@onready var timer = $Timer
@onready var animator : AnimationPlayer = $AnimationPlayer

var healed = false

func _ready():
	timer.start()
	check_heals()

func remove_not_heal_sources(obj):
	return obj.is_in_group("Heal")


func check_heals():
	var heals = get_overlapping_areas().filter(remove_not_heal_sources).size()
	if controller.health < 10 && heals > 0:
		# do funcs popHeal() -> INT on heals areas
		controller.health +=1
		animator.play("Healing")
		healed = true
		return
	if healed:
		animator.play("StopHealing")
		healed = false


func _on_timer_timeout():
	check_heals()
