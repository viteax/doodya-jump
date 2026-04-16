extends CharacterBody2D

@onready var area_2d: Area2D = $Area2D
@onready var notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var hint_label: Label = $HintLabel

@export var shop_gui_scene: PackedScene

var gui_open := false
var player_nearby := false

func _ready():
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)
	notifier.screen_exited.connect(queue_free)


func _unhandled_input(event):
	if player_nearby and not gui_open and event.is_action_pressed("shoot"):
		gui_open = true
		get_tree().paused = true
		var gui = shop_gui_scene.instantiate()
		gui.tree_exiting.connect(func(): gui_open = false)
		get_tree().current_scene.add_child(gui)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true
		hint_label.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
		hint_label.visible = false
