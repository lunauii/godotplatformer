extends KinematicBody2D

signal coin_collected

var velocity = Vector2(0, 0)
var jumpsLeft = 0
const SPEED = 25
const GRAVITY = 30
const JUMPFORCE = -950
const TERMINALVELOCITY = 1000

func _physics_process(delta):
	
	velocity.y = velocity.y+GRAVITY
	if velocity.y >= TERMINALVELOCITY:
		velocity.y = TERMINALVELOCITY
	
	if Input.is_action_pressed("right"):
		velocity.x += SPEED
		velocity.x *= pow(1.0, delta)
		$Sprite.play("walk")
		$Sprite.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x += -SPEED
		velocity.x *= pow(1.0, delta)
		$Sprite.play("walk")
		$Sprite.flip_h = true
	else:
		$Sprite.play("idle")
		
	if not is_on_floor():
		$Sprite.play("jump")
	elif is_on_floor():
		jumpsLeft = 1
		
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMPFORCE
	elif Input.is_action_just_pressed("jump") and jumpsLeft != 0:
		velocity.y = JUMPFORCE
		jumpsLeft -= 1

	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.x = lerp(velocity.x, 0, 0.1)


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
