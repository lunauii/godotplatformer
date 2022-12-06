extends Area2D

func _on_obj_coin_body_entered(body):
	body.add_coin()
	#$CollisionShape2D.queue_free()
	$AnimationPlayer.play("bounce")
	set_collision_mask_bit(0,false)

func _on_AnimationPlayer_animation_finished(bounce):
	queue_free()
