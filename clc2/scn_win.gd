extends Control
var time_elapsed = Global.time_elapsed

func _ready():
	$timelabelwin.text = String(time_elapsed)	
