extends Node2D

@export var enemy_scenes: Array[PackedScene] = []
@export var min_x: float = 100.0
@export var max_x: float = 560.0
@export var max_enemies: int = 5

@export var camera: Camera2D

@onready var timer: Timer = $Timer
var _enemy_count: int = 0

const BASE_INTERVAL: float = 7.0
const MIN_INTERVAL: float = 2.5

func _ready():
	timer.wait_time = BASE_INTERVAL
	timer.timeout.connect(_spawn)
	timer.start()

func _spawn():
	if enemy_scenes.is_empty() or _enemy_count >= max_enemies:
		return

	var d = Difficulty.get_d(camera.global_position.y)
	timer.wait_time = lerpf(BASE_INTERVAL, MIN_INTERVAL, d)

	var x = randf_range(min_x, max_x)
	var y = camera.global_position.y - get_viewport_rect().size.y

	var enemy = enemy_scenes.pick_random().instantiate()
	enemy.global_position = Vector2(x, y)
	enemy.tree_exiting.connect(_on_enemy_removed)

	get_tree().current_scene.add_child(enemy)
	_enemy_count += 1

func _on_enemy_removed():
	_enemy_count -= 1
