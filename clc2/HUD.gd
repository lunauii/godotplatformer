extends CanvasLayer

var coins = 0
var time_start = 0
var time_now = 0
var time_elapsed = 0

var win_condition = LevelList.WinConditions.LEVEL1

func _ready():
	time_start = OS.get_ticks_msec()
	set_process(true)
	
func _process(delta):
	match LevelList.WinConditions:
		LevelList.WinConditions.LEVEL1:
			if get_tree().current_scene.name == "scn_level2":
				win_condition = LevelList.WinConditions.LEVEL2
				continue
		LevelList.WinConditions.LEVEL2:
			pass

	$Coins.text = String(coins)

	time_now = OS.get_ticks_msec() 
	var elapsed = time_now - time_start
	var millis = elapsed /10 % 100
	var seconds = elapsed / 1000 % 60
	var minutes = (elapsed/(1000*60))%60
	var time_elapsed = "%02d:%02d.%02d" % [minutes, seconds, millis]
	$timelabel.text = String(time_elapsed)	
	Global.time_elapsed = time_elapsed
	
	
	
func _on_coin_collected():
	coins += 1
	if coins == win_condition:
		get_tree().change_scene("res://scn_win.tscn")
#		LevelList.



func initialize(preloadedScene, parent_node):
	var preloadedSceneInstance = preloadedScene.instance()
	if parent_node:
		parent_node.add_child(preloadedSceneInstance)
	else:
		add_child(preloadedSceneInstance)
	return preloadedSceneInstance
	



