extends Node2D

@export var gear_scene: PackedScene
@export var camera: Camera2D

var last_spawn_y: float = Difficulty.START_Y
var screen_width: float

const BASE_MIN_GAP: float = 150.0
const BASE_MAX_GAP: float = 300.0
const MAX_MIN_GAP: float = 300.0
const MAX_MAX_GAP: float = 550.0

func _ready():
	screen_width = get_viewport_rect().size.x

func _process(_delta):
	var spawn_threshold = camera.global_position.y - get_viewport_rect().size.y
	while last_spawn_y > spawn_threshold:
		_spawn_gear()

	var delete_line = camera.global_position.y + get_viewport_rect().size.y
	for gear in get_children():
		if gear.global_position.y > delete_line:
			gear.queue_free()

func _spawn_gear():
	var d = Difficulty.get_d(camera.global_position.y)
	var min_gap = lerpf(BASE_MIN_GAP, MAX_MIN_GAP, d)
	var max_gap = lerpf(BASE_MAX_GAP, MAX_MAX_GAP, d)

	last_spawn_y -= randf_range(min_gap, max_gap)

	var margin = 40.0
	var x = randf_range(margin, screen_width - margin)

	var gear = gear_scene.instantiate()
	gear.global_position = Vector2(x, last_spawn_y)
	add_child(gear)
