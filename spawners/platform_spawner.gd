extends Node2D

@export var static_platform: PackedScene
@export var moving_platform: PackedScene
@export var breaking_platform: PackedScene

@export var enemy_scene: PackedScene
@export var spawn_chance: float = 0.1

@export var shop_scene: PackedScene
@export var shop_spawn_chance: float = 0.1

@export var camera: Camera2D

var last_spawn_y: float = 427.0
var min_gap_y: float = 70.0
var max_gap_y: float = 110.0
var screen_width: float

func _ready():
	screen_width = get_viewport_rect().size.x
	# генерируем стартовый набор платформ
	for i in range(10):
		spawn_platform()

func _process(_delta):
	# генерируем новые, когда камера приближается к верхней платформе
	var spawn_threshold = camera.global_position.y - get_viewport_rect().size.y
	while last_spawn_y > spawn_threshold:
		spawn_platform()
	
	# удаляем платформы, ушедшие далеко вниз
	var delete_line = camera.global_position.y + get_viewport_rect().size.y
	for platform in get_children():
		if platform.global_position.y > delete_line:
			platform.queue_free()

func spawn_platform():
	var platform = get_random_platform()
	
	var gap = randf_range(min_gap_y, max_gap_y)
	last_spawn_y -= gap
	
	var margin = 40.0
	var x = randf_range(margin, screen_width - margin)
	
	platform.global_position = Vector2(x, last_spawn_y)
	add_child(platform)
	
	if enemy_scene and randf() < spawn_chance:
		var enemy = enemy_scene.instantiate()
		enemy.global_position = platform.global_position + Vector2(0, -30)
		add_child(enemy)
		return
	
	if shop_scene and randf() < shop_spawn_chance:
		var enemy = shop_scene.instantiate()
		enemy.global_position = platform.global_position + Vector2(0, -30)
		add_child(enemy)
		return


func get_random_platform() -> Node2D:
	var roll = randf()
	if roll < 0.7:
		return static_platform.instantiate()
	elif roll < 0.9:
		return moving_platform.instantiate()
	else:
		return breaking_platform.instantiate()
