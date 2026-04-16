extends Node2D

@onready var play_button: Button = $CanvasLayer/Panel/VBox/PlayButton
@onready var best_label: Label = $CanvasLayer/Panel/VBox/BestLabel

func _ready():
	play_button.pressed.connect(_on_play)
	var best = SaveManager.best_height
	if best > 0:
		best_label.text = "Рекорд: %dм" % best
	else:
		best_label.text = ""

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		_on_play()

func _on_play():
	get_tree().change_scene_to_file("res://main.tscn")
