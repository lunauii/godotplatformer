extends Area2D

func _on_obj_coin_body_entered(body):
	body.add_coin()
	$CollisionShape2D.queue_free()
	set_collision_mask_bit(0,false)
	$sfx_coincollected.play()
	$AnimationPlayer.play("invis")

func _on_AnimationPlayer_animation_finished(invis):
	queue_free()
