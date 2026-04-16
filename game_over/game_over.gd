extends CanvasLayer

@onready var height_label: Label = $Panel/VBox/HeightLabel
@onready var gears_label: Label = $Panel/VBox/GearsLabel
@onready var best_label: Label = $Panel/VBox/BestLabel
@onready var restart_button: Button = $Panel/VBox/RestartButton
@onready var menu_button: Button = $Panel/VBox/MenuButton

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true

	height_label.text = "Высота: %dм" % SaveManager.last_session_height
	gears_label.text = "Шестерёнки: %d" % SaveManager.last_session_gears
	best_label.text = "Рекорд: %dм" % SaveManager.best_height

	restart_button.pressed.connect(_restart)
	menu_button.pressed.connect(_go_menu)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		_restart()

func _restart():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _go_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
