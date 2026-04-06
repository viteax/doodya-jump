extends Node2D

@export var shop_scene: PackedScene
@export var spawn_interval: float = 15.0
@export var min_x: float = 100.0
@export var max_x: float = 560.0
@export var max_shops: int = 1          # usually only 1 shop on screen at a time

@export var camera: Camera2D

@onready var timer: Timer = $Timer
var _shop_count: int = 0

func _ready():
	timer.wait_time = spawn_interval
	timer.timeout.connect(_spawn)
	timer.start()

func _spawn():
	if shop_scene == null or _shop_count >= max_shops:
		return

	var y_pos = camera.global_position.y - get_viewport_rect().size.y

	var shop = shop_scene.instantiate()
	shop.global_position = global_position
	shop.global_position.x += randf_range(min_x, max_x)
	shop.global_position.y += y_pos
	shop.tree_exiting.connect(_on_shop_removed)

	get_tree().current_scene.add_child(shop)
	_shop_count += 1

func _on_shop_removed():
	_shop_count -= 1
