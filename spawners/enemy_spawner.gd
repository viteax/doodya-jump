extends Node2D

@export var enemy_scenes: Array[PackedScene] = []
@export var spawn_interval: float = 7.0
@export var min_x: float = 100.0
@export var max_x: float = 560.0
@export var max_enemies: int = 5

@export var camera: Camera2D

@onready var timer: Timer = $Timer
var _enemy_count: int = 0

func _ready():
	timer.wait_time = spawn_interval
	timer.timeout.connect(_spawn)
	timer.start()

func _spawn():
	if enemy_scenes.is_empty() or _enemy_count >= max_enemies:
		return
	
	# генерируем новые, когда камера приближается к верхней платформе
	var y_pos = camera.global_position.y - get_viewport_rect().size.y

	var scene = enemy_scenes.pick_random()
	var enemy = scene.instantiate()
	enemy.global_position = global_position
	enemy.global_position.x += randf_range(min_x, max_x)
	enemy.global_position.y += y_pos
	enemy.tree_exiting.connect(_on_enemy_removed)

	get_tree().current_scene.add_child(enemy)
	_enemy_count += 1

func _on_enemy_removed():
	_enemy_count -= 1
