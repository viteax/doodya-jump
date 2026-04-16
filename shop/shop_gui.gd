extends CanvasLayer

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
	SaveManager.gears_changed.connect(func(_g): _refresh())
	_focus_first()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		_close()
	elif event is InputEventKey and event.pressed:
		if event.keycode == KEY_W:
			_move_focus(-1)
		elif event.keycode == KEY_S:
			_move_focus(1)

func _move_focus(dir: int):
	var buttons = [gun_button, lvl1_button, lvl2_button, lvl3_button, lvl4_button, close_button]
	var focused = get_viewport().gui_get_focus_owner()
	var idx = buttons.find(focused)
	if idx == -1:
		_focus_first()
		return
	var next = (idx + dir) % buttons.size()
	if next < 0:
		next = buttons.size() - 1
	buttons[next].grab_focus()

func _refresh():
	gears_label.text = "Gears: %d" % SaveManager.gears
	gun_button.text   = "Gun — %dg" % SaveManager.PRICES["gun"]
	gun_button.disabled = SaveManager.has_gun or SaveManager.gears < SaveManager.PRICES["gun"]
	if SaveManager.has_gun:
		gun_button.text = "Gun (owned)"

	var level_buttons = [lvl1_button, lvl2_button, lvl3_button, lvl4_button]
	for i in range(4):
		var lvl = i + 1
		var key = "level%d" % lvl
		var price = SaveManager.PRICES[key]
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
	if SaveManager.remove_gears(SaveManager.PRICES["gun"]):
		SaveManager.acquire_gun()
		status_label.text = "Gun unlocked!"

func _buy_level(lvl: int):
	var key = "level%d" % lvl
	if SaveManager.level >= lvl:
		return
	if SaveManager.remove_gears(SaveManager.PRICES[key]):
		SaveManager.level = lvl
		status_label.text = "Level %d unlocked!" % lvl

func _focus_first():
	var buttons = [gun_button, lvl1_button, lvl2_button, lvl3_button, lvl4_button, close_button]
	for btn in buttons:
		if not btn.disabled:
			btn.grab_focus()
			return
	close_button.grab_focus()

func _close():
	get_tree().paused = false
	queue_free()
