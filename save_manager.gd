extends Node

const SAVE_PATH = "user://save.dat"

const PRICES = {
	"gun":    50,
	"level1": 30,
	"level2": 80,
	"level3": 150,
	"level4": 300,
}

var gears: int = 0:
	set(value):
		gears = value
		gears_changed.emit(gears)

var level: int = 0:
	set(value):
		level = value
		level_changed.emit(level)

var best_height: int = 0

# результаты последней сессии (не сохраняются на диск)
var last_session_height: int = 0
var last_session_gears: int = 0

var has_gun: bool = false:
	set(value):
		has_gun = value
		if value:
			gun_acquired.emit()

signal gears_changed(amount: int)
signal level_changed(level: int)
signal gun_acquired

func _ready():
	load_data()

func reset():
	#gears = 0
	level = 0
	has_gun = false
	save()

func acquire_gun():
	has_gun = true
	save()

func level_up():
	if level < 4:
		level += 1
		save()

func add_gears(amount: int):
	gears += amount
	save()

func remove_gears(amount: int) -> bool:
	if amount <= gears:
		gears -= amount
		save()
		return true
	return false

func update_best_height(height: int):
	if height > best_height:
		best_height = height
		save()

func save():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var({"gears": gears, "level": level, "has_gun": has_gun, "best_height": best_height})

func load_data():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var data = file.get_var()
		gears = data.get("gears", 0)
		level = data.get("level", 0)
		has_gun = data.get("has_gun", false)
		best_height = data.get("best_height", 0)
