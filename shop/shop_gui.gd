extends CanvasLayer

signal closed

const PRICES = {
	"gun":    50,
	"level1": 30,
	"level2": 80,
	"level3": 150,
	"level4": 300,
}

@onready var gears_label: Label     = $Panel/VBox/GearsLabel
@onready var status_label: Label    = $Panel/VBox/StatusLabel
@onready var gun_button: Button     = $Panel/VBox/GunButton
@onready var lvl1_button: Button    = $Panel/VBox/Lvl1Button
@onready var lvl2_button: Button    = $Panel/VBox/Lvl2Button
@onready var lvl3_button: Button    = $Panel/VBox/Lvl3Button
@onready var lvl4_button: Button    = $Panel/VBox/Lvl4Button
@onready var close_button: Button   = $Panel/VBox/CloseButton

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	_refresh()
	gun_button.pressed.connect(_buy_gun)
	lvl1_button.pressed.connect(func(): _buy_level(1))
	lvl2_button.pressed.connect(func(): _buy_level(2))
	lvl3_button.pressed.connect(func(): _buy_level(3))
	lvl4_button.pressed.connect(func(): _buy_level(4))
	close_button.pressed.connect(_close)

func _refresh():
	gears_label.text = "Gears: %d" % SaveManager.gears
	gun_button.text   = "Gun — %dg" % PRICES["gun"]
	gun_button.disabled = SaveManager.has_gun or SaveManager.gears < PRICES["gun"]
	if SaveManager.has_gun:
		gun_button.text = "Gun (owned)"

	var level_buttons = [lvl1_button, lvl2_button, lvl3_button, lvl4_button]
	for i in range(4):
		var lvl = i + 1
		var key = "level%d" % lvl
		var price = PRICES[key]
		var btn: Button = level_buttons[i]
		if SaveManager.level >= lvl:
			btn.text = "Level %d (owned)" % lvl
			btn.disabled = true
		elif SaveManager.gears < price:
			btn.text = "Level %d — %dg" % [lvl, price]
			btn.disabled = true
		else:
			btn.text = "Level %d — %dg" % [lvl, price]
			btn.disabled = false

	status_label.text = ""

func _buy_gun():
	if SaveManager.has_gun or SaveManager.gears < PRICES["gun"]:
		return
	SaveManager.gears -= PRICES["gun"]
	SaveManager.has_gun = true
	SaveManager.save()
	status_label.text = "Gun unlocked!"
	_refresh()

func _buy_level(lvl: int):
	var key = "level%d" % lvl
	var price = PRICES[key]
	if SaveManager.level >= lvl or SaveManager.gears < price:
		return
	SaveManager.gears -= price
	SaveManager.level = lvl
	SaveManager.save()
	status_label.text = "Level %d unlocked!" % lvl
	_refresh()

func _close():
	get_tree().paused = false
	closed.emit()
	queue_free()
