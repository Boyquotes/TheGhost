extends Node3D
@onready var animator : AnimationPlayer = get_node("AnimationPlayer")
@onready var animator2 = $AnimationPlayer2
@onready var controller : RigidBody3D = get_parent()
@onready var light : OmniLight3D = get_tree().get_first_node_in_group("PlayerLight")
@onready var label : Label3D = get_node("Label3D")
@onready var skeleton : Skeleton3D = $Armature/Skeleton3D

var is_walking = false
var is_jumping = false

func _ready():
	animator2.play("Spawn")

var is_hit = false :
	set(value):
		if value == true:
			is_hit = true
			skeleton.physical_bones_start_simulation()
			animator2.play("Despawn")
			await get_tree().create_timer(2).timeout
			skeleton.physical_bones_stop_simulation()
			light.blink()
			rotation.y = atan2(-controller.motion.x, -controller.motion.z)
			animator2.play("Spawn")
			is_hit = false
		else:
			is_hit = false
			
func _physics_process(delta):
	if is_walking:
		animator.speed_scale = lerpf(animator.speed_scale, controller.linear_velocity.length() / controller.MAX_SPEED, delta * 10.0)
	if is_walking && is_hit:
		animator.play("walking_soundless")
	if is_walking and !is_hit and animator.current_animation == "walking_soundless":
		animator.play("walking")

func _on_sm_entered_state(state, startSec):
	label.override(state)
	if(animator.has_animation(state)):
		if state in ["walking"] :
			animator.playback_default_blend_time = 0.3
			is_walking = true
		elif state in ["landing"]:
			animator.playback_default_blend_time = 0
			animator.speed_scale = 1.2
			is_walking = false
		else :
			animator.playback_default_blend_time = 0.3
			animator.speed_scale = 1.0
			is_walking = false
		animator.play(state)
		animator.seek(startSec, true)

func hit() -> void:
	is_hit = true
