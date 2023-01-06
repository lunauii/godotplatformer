extends KinematicBody2D

signal coin_collected

enum States {
	AIR = 1,
	FLOOR,
	CLIMBING,
	WALL,
}
var state = States.AIR
var time = preload("res://Global.tscn")

var velocity = Vector2.ZERO
var player_direction = 1

const SPEED = 250
const RUNSPEED = 480
const DASHSPEED = 9000
const DASHDURATION = 0.2
const GRAVITY = 30
const JUMPFORCE = -950
const TERMINALVELOCITY = 1000

onready var animate = $Sprite
onready var dash = $Dash

onready var dust_particles_placeholder = get_node("DustParticlesPlaceholder")
onready var dust_particles_scene = preload("res://DustParticles.tscn")



func _physics_process(delta):
	print(velocity.y)
	
	var move_direction = get_move_direction()
	play_animation(move_direction)

	if Input.is_action_just_pressed("dash") && dash.can_dash && !dash.is_dashing():
		velocity = lerp(velocity, DASHSPEED * move_direction.normalized(), 0.2)
		dash.start_dash(DASHDURATION)
		velocity.x *= 2
		velocity.y *= 0.66
		
		
	print(move_direction.normalized())
		
	match state:
		States.AIR:
			if is_on_floor():
				state = States.FLOOR
				continue
			
			if move_direction.normalized()[0] != 0:
				if Input.is_action_pressed("run"):
					velocity.x = lerp(velocity.x, RUNSPEED * move_direction.normalized()[0], 0.2)
				else:
					velocity.x = lerp(velocity.x, SPEED * move_direction.normalized()[0], 0.2)
			else:
				velocity.x = lerp(velocity.x, 0, 0.2)
			animate.play("jump")
			move_and_fall() 



		States.FLOOR:
			if not is_on_floor():
				state = States.AIR
			
			if move_direction.normalized()[0] != 0:
				if Input.is_action_pressed("run"):
					velocity.x = lerp(velocity.x, RUNSPEED * move_direction.normalized()[0], 0.2)
					animate.set_speed_scale(1.8)
				else:
					velocity.x = lerp(velocity.x, SPEED * move_direction.normalized()[0], 0.2)
					animate.set_speed_scale(1.0)
			else:
				velocity.x = lerp(velocity.x, 0, 0.2)
			if Input.is_action_pressed("jump"):
				velocity.y = JUMPFORCE
				create_dust_particles()
				$sfx_jump.play()
			
			move_and_fall() 



func get_move_direction():
	return Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
		
	)

func play_animation(move_direction):
	if move_direction == Vector2.ZERO:
		animate.play("idle")
	else:
		animate.flip_h = move_direction.x < 0
		animate.play("walk")

func move_and_fall():
	velocity.y = velocity.y+GRAVITY
	
	if velocity.y >= TERMINALVELOCITY:
		velocity.y = TERMINALVELOCITY
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_fallzone_body_entered(body):
	get_tree().change_scene("res://scn_losescreen.tscn")



func bounce():
	velocity.y = JUMPFORCE * 0.725



func hurt(var enemyposx):
	if dash.is_dashing():
		return
	set_modulate(Color(1, 0.3, 0.3, 0.34))
	velocity.y = JUMPFORCE * 0.5
	
	if position.x < enemyposx:
		velocity.x = -750
	elif position.x > enemyposx:
		velocity.x = 750
	else:
		pass
	
	Input.action_release("left")
	Input.action_release("right")
	
	$Timer.start()



func add_coin():
	emit_signal("coin_collected")



func _on_Timer_timeout():
	get_tree().change_scene("res://scn_losescreen.tscn")

	
func create_dust_particles():
	var dust_particles_instance = get_parent().get_node("HUD").initialize(dust_particles_scene, self)
	dust_particles_instance.set_as_toplevel(true)
	dust_particles_instance.scale.x = player_direction
	dust_particles_instance.global_position = dust_particles_placeholder.global_position
