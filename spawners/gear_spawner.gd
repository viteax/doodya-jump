extends Node2D

@export var gear_scene: PackedScene

@export var camera: Camera2D

var last_spawn_y: float = 427.0
var min_gap_y: float = 150.0
var max_gap_y: float = 300.0
var screen_width: float

func _ready():
	screen_width = get_viewport_rect().size.x

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
	var platform = gear_scene.instantiate()
	
	var gap = randf_range(min_gap_y, max_gap_y)
	last_spawn_y -= gap
	
	var margin = 40.0
	var x = randf_range(margin, screen_width - margin)
	
	platform.global_position = Vector2(x, last_spawn_y)
	add_child(platform)
