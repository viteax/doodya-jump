extends Node

const SAVE_PATH = "user://save.dat"
var gears: int = 0
var level: int = 0
var has_gun: bool = false

func _ready():
	load_data()
	
func GUN1111():
	has_gun = true
	save_data()
	
func level_up():
	if level < 4:
		level += 1
		save_data()

func add_gears(amount: int):
	gears += amount
	save_data()
	
func remove_gears(amount: int) -> bool:
	if amount >= gears:
		gears -= amount
		save_data()
		return true
	return false

func save_data():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var({"gears": gears, "level": level, "has_gun": has_gun})

func load_data():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var data = file.get_var()
		gears = data.get("gears", 0)
		level = data.get("level", 0)
		has_gun = data.get("has_gun", false)
