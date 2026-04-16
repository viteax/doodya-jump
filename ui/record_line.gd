extends Node2D

@export var camera: Camera2D

const HEIGHT_SCALE: float = 24.0
const PLAYER_START_Y: float = 218.0

var _label: Label

func _ready():
	if SaveManager.best_height <= 0:
		visible = false
		return

	global_position.y = PLAYER_START_Y - SaveManager.best_height * HEIGHT_SCALE

	var font = load("res://monogram.ttf")
	_label = Label.new()
	_label.text = "— Рекорд: %dм" % SaveManager.best_height
	_label.position = Vector2(8, -28)
	_label.add_theme_font_override("font", font)
	_label.add_theme_color_override("font_color", Color(1, 0.85, 0.2, 0.9))
	_label.add_theme_font_size_override("font_size", 24)
	add_child(_label)

func _draw():
	if SaveManager.best_height <= 0:
		return
	var w = get_viewport_rect().size.x
	draw_dashed_line(Vector2(0, 0), Vector2(w, 0), Color(1, 0.85, 0.2, 0.7), 2.0, 16.0)
