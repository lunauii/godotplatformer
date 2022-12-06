extends KinematicBody2D

var velocity = Vector2()
var speed = 50
enum DirectionEnum {
	LEFT = -1, 
	RIGHT = 1
	}
export(DirectionEnum) var direction
export var canDetectEdge = true

func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = true
	$floor_check.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$floor_check.enabled = canDetectEdge
	if canDetectEdge:
		set_modulate(Color(1, 1, 1))
	else:
		set_modulate(Color(1.2,0.5,1))

func _physics_process(delta):
	
	if is_on_wall() or not $floor_check.is_colliding() and canDetectEdge and is_on_floor():
		direction *= -1
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
		$floor_check.position.x = $CollisionShape2D.shape.get_extents().x * direction
	
	velocity.y += 20
	velocity.x = speed * direction
	
	velocity = move_and_slide(velocity,Vector2.UP)




func _on_top_check_body_entered(body):
	if body.collision_layer == 1:
		$AnimatedSprite.play("death")
		speed = 0
		set_collision_layer_bit(4, false)
		set_collision_mask_bit(0, false)
		$top_check.set_collision_layer_bit(4, false)
		$top_check.set_collision_mask_bit(0, false)
		$side_check.set_collision_layer_bit(4, false)
		$side_check.set_collision_mask_bit(0, false)
		$Timer.start()
		body.bounce()
		
func _on_side_check_body_entered(body):
	if body.collision_layer == 1:
		print("Ouch!")
		body.hurt(position.x)
	


func _on_Timer_timeout():
	queue_free()
