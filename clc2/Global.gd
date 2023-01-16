extends Node

var time_now = 0
var time_start = 0
var time_elapsed = 0

func _process(delta):
	time_now = OS.get_ticks_msec() 
	var elapsed = time_now - time_start
	var millis = elapsed /10 % 100
	var seconds = elapsed / 1000 % 60
	var minutes = (elapsed/(1000*60))%60
	time_elapsed = "%02d:%02d.%02d" % [minutes, seconds, millis]
