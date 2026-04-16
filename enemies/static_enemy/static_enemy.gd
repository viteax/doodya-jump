extends CharacterBody2D

@export var gear_scene: PackedScene

@onready var area_2d: Area2D = $Area2D
@onready var notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func die():
	if gear_scene == null:
		return
	var gear = gear_scene.instantiate()
	gear.global_position = global_position
	get_tree().current_scene.add_child.call_deferred(gear)
	queue_free()


func _ready():
	area_2d.body_entered.connect(_on_body_entered)
	notifier.screen_exited.connect(queue_free)


func _on_body_entered(body):
	if body.is_in_group("player"):
		body.die()
		return
