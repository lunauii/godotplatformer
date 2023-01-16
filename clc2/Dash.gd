extends Node2D

const dash_delay = 25.0

onready var duration_timer = $DurationTimer
onready var ghost_timer = $GhostTimer
onready var dust_trail = $DustTrail
onready var dust_burst = $DustBurst
var ghost_scene = preload("res://DashGhost.tscn")
var can_dash = true
var animatedsprite


func start_dash(animatedsprite, duration, direction):
	self.animatedsprite = animatedsprite
	animatedsprite.material.set_shader_param("mix_weight", 0.7)
	animatedsprite.material.set_shader_param("whiten", true)
	
	duration_timer.wait_time = duration
	duration_timer.start()
	
	ghost_timer.start()
	instance_ghost()
	
	dust_trail.restart()
	dust_trail.emitting = true
	
	dust_burst.rotation = (direction * -1).angle()
	dust_burst.restart()
	dust_burst.emitting = true

func instance_ghost():
	var ghost: AnimatedSprite = ghost_scene.instance()
	get_parent().get_parent().add_child(ghost)
	
	ghost.global_position = global_position
	ghost.animation = animatedsprite.animation
	ghost.speed_scale = animatedsprite.speed_scale
	ghost.flip_h = animatedsprite.flip_h
	

func is_dashing():
	return !duration_timer.is_stopped()

func end_dash():
	ghost_timer.stop()
	animatedsprite.material.set_shader_param("whiten", false)
	
	can_dash = false
	yield(get_tree().create_timer(dash_delay), 'timeout')
	can_dash = true

func _on_DurationTimer_timeout() -> void:
	end_dash()

func _on_GhostTimer_timeout() -> void:
	instance_ghost()
