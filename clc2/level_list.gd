extends Node

const _order = [
	#World 1 // Purple Sky
	"scn_level1",
	"scn_level2"
]
enum WinConditions {
	LEVEL1 = 7,
	LEVEL2,
	LEVEL3
}



static func get_level(var index: int):
	return load(str("res://", _order[index], ".tscn"))
