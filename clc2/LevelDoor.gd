extends Area2D

signal level_changed

export (String) var level_name = "level"

func _on_LevelDoor_body_entered(body) -> void:
	if body.collision_layer == 1:
		emit_signal("level_changed", level_name)
