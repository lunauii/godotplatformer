extends KinematicBody2D

var velocity = Vector2(0, 0)

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		velocity.x = 150
	if Input.is_action_pressed("left"):
		velocity.x = -150
		
	move_and_slide(velocity)
	
	velocity.x = lerp(velocity.x, 0, 0.15)
