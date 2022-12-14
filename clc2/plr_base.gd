extends KinematicBody2D

signal coin_collected

enum States {
	AIR = 1,
	FLOOR,
	CLIMBING,
	WALL,
}
var state = States.AIR

var velocity = Vector2.ZERO
var old_position = Vector2.ZERO
const SPEED = 250
const RUNSPEED = 480
const GRAVITY = 30
const JUMPFORCE = -950
const TERMINALVELOCITY = 1000



func _physics_process(delta):
	print(velocity.x)
	match state:
		States.AIR:
			if is_on_floor():
				state = States.FLOOR
				continue
			if Input.is_action_pressed("right"):
				if Input.is_action_pressed("run"):
					velocity.x = lerp(velocity.x, RUNSPEED, 0.1) if velocity.x < RUNSPEED else lerp(velocity.x, RUNSPEED, 0.04)
					$Sprite.flip_h = false
				else:
					velocity.x = lerp(velocity.x, SPEED, 0.1) if velocity.x < SPEED else lerp(velocity.x, SPEED, 0.04)
					$Sprite.flip_h = false
			elif Input.is_action_pressed("left"):
				if Input.is_action_pressed("run"):
					velocity.x = lerp(velocity.x, -RUNSPEED, 0.1)if velocity.x < RUNSPEED else lerp(velocity.x, -RUNSPEED, 0.04)
					$Sprite.flip_h = true
				else:
					velocity.x = lerp(velocity.x, -SPEED, 0.1) if velocity.x < SPEED else lerp(velocity.x, -SPEED, 0.04)
					$Sprite.flip_h = true
			else:
				velocity.x = lerp(velocity.x, 0, 0.2)
			$Sprite.play("jump")
			move_and_fall() 
			
		States.FLOOR:
			if not is_on_floor():
				state = States.AIR
			if Input.is_action_pressed("right"):
				if Input.is_action_pressed("run"):
					velocity.x = lerp(velocity.x, RUNSPEED, 0.1)
					$Sprite.set_speed_scale(1.8)
					$Sprite.flip_h = false
				else:
					velocity.x = lerp(velocity.x, SPEED, 0.1)
					$Sprite.set_speed_scale(1.0)
					$Sprite.flip_h = false
			elif Input.is_action_pressed("left"):
				if Input.is_action_pressed("run"):
					velocity.x = lerp(velocity.x, -RUNSPEED, 0.1)
					$Sprite.set_speed_scale(1.8)
					$Sprite.flip_h = true
				else:
					velocity.x = lerp(velocity.x, -SPEED, 0.1)
					$Sprite.set_speed_scale(1.0)
					$Sprite.flip_h = true
			else:
				velocity.x = lerp(velocity.x, 0, 0.2)
			if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
				$Sprite.play("walk")
			else:
				$Sprite.play("idle")
				
			if Input.is_action_pressed("jump"):
				velocity.y = JUMPFORCE
				$sfx_jump.play()
			
			move_and_fall() 



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
