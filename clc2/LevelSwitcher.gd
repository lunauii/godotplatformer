extends Node

onready var current_level = $scn_level1

#func _ready():
#	current_level.connect("level_changed", self, "handle_level_changed")
	
#func handle_level_changed(current_level_name: String):
#	var next_level
#	var next_level_name: String
#
#	match current_level_name:
#		"level1":
#			next_level_name = "level2"
#		"level2":
#			next_level_name = "level1"
#		_:
#			return
#
#	next_level = load("res://" + next_level_name + ".tscn").instance()
#	add_child(next_level)
#	next_level.connect("level_changed", self, "handle_level_changed")
#	current_level.queue_free()
#	current_level = next_level


func _on_LevelDoor_level_changed(current_level_name):
	var next_level
	var next_level_name: String
	
	match current_level_name:
		"level1":
			next_level_name = "level2"
		"level2":
			next_level_name = "level1"
		_:
			return
	
	next_level = load("res://scn_" + next_level_name + ".tscn").instance()
	add_child(next_level)
	next_level.connect("level_changed", self, "_on_LevelDoor_level_changed")
	current_level.queue_free()
	current_level = next_level
