extends Node

const SAVE_PATH = "user://save.dat"
var gears: int = 0

func _ready():
	load_data()

func add_gears(amount: int):
	gears += amount
	save_data()

func save_data():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var({"gears": gears})

func load_data():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var data = file.get_var()
		gears = data.get("gears", 0)
