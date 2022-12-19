extends Node3D
@onready var animator : AnimationPlayer = get_node("AnimationPlayer")
@onready var animator2 = $AnimationPlayer2
@onready var controller : RigidBody3D = get_parent()
@onready var light : OmniLight3D = get_tree().get_first_node_in_group("PlayerLight")
@onready var label : Label3D = get_node("Label3D")

var is_walking = false
var is_jumping = false

func _ready():
	animator2.play("Spawn")

var is_hit = true :
	set(value):
		if value == true:
			is_hit = true
			$Armature/Skeleton3D.physical_bones_start_simulation()
			animator2.play("Despawn")
			await get_tree().create_timer(2).timeout
			$Armature/Skeleton3D.physical_bones_stop_simulation()
			light.blink()
			rotation.y = atan2(-controller.motion.x, -controller.motion.z)
			animator2.play("Spawn")
			is_hit = false
		else:
			is_hit = false
			
func _physics_process(delta):
	if is_walking:
		animator.playback_speed = lerpf(animator.playback_speed, controller.linear_velocity.length() / controller.MAX_SPEED, delta * 10.0)

func _on_sm_entered_state(state, startSec):
	#label.hard_reset()
	#label.override(state)
	if(animator.has_animation(state)):
		if state in ["walking"] :
			is_walking = true
		else :
			animator.playback_speed = 1.0
			is_walking = false
		if state in ["landing"]:
			animator.playback_default_blend_time = 0
		else :
			animator.playback_default_blend_time = 0.3
		animator.play(state)
		animator.seek(startSec, true)

func hit() -> void:
	is_hit = true
