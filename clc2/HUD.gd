extends CanvasLayer

var coins = 0
var winCondition = 3

func _physics_process(delta):
	if coins == winCondition:
		get_tree().change_scene("res://scn_level1.tscn")
		
		
		
func _ready():
	$Coins.text = String(coins)
	
	
	
func _on_coin_collected():
	coins += 1
	print("Coins: ", coins)
	_ready()



