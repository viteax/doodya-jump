extends Node2D

@export var static_platform: PackedScene
@export var moving_platform: PackedScene
@export var breaking_platform: PackedScene

@export var enemy_scene: PackedScene
@export var shop_scene: PackedScene

@export var camera: Camera2D

var last_spawn_y: float = Difficulty.START_Y
var last_enemy_y: float = 0.0
var last_shop_y: float = 0.0
var screen_width: float

const MIN_ENEMY_GAP: float = 300.0
const MIN_SHOP_GAP: float = 500.0

const BASE_MIN_GAP: float = 70.0
const BASE_MAX_GAP: float = 110.0
const BASE_ENEMY_CHANCE: float = 0.1
const BASE_SHOP_CHANCE: float = 0.1

const MAX_MIN_GAP: float = 130.0
const MAX_MAX_GAP: float = 190.0
const MAX_ENEMY_CHANCE: float = 0.35

enum PlatformType { STATIC, MOVING, BREAKING }

func _ready():
	screen_width = get_viewport_rect().size.x
	for i in range(10):
		spawn_platform()

func _process(_delta):
	var spawn_threshold = camera.global_position.y - get_viewport_rect().size.y
	while last_spawn_y > spawn_threshold:
		spawn_platform()

	var delete_line = camera.global_position.y + get_viewport_rect().size.y
	for platform in get_children():
		if platform.global_position.y > delete_line:
			platform.queue_free()

func spawn_platform():
	var d = Difficulty.get_d(camera.global_position.y)
	var min_gap = lerpf(BASE_MIN_GAP, MAX_MIN_GAP, d)
	var max_gap = lerpf(BASE_MAX_GAP, MAX_MAX_GAP, d)
	var enemy_chance = lerpf(BASE_ENEMY_CHANCE, MAX_ENEMY_CHANCE, d)

	var type = _get_random_platform_type(d)
	var platform = _get_platform_by_type(type)
	var gap = randf_range(min_gap, max_gap)
	last_spawn_y -= gap

	var margin = 40.0
	var x = randf_range(margin, screen_width - margin)
	platform.global_position = Vector2(x, last_spawn_y)
	add_child(platform)

	var enemy_gap_ok = abs(last_spawn_y - last_enemy_y) >= MIN_ENEMY_GAP
	if type == PlatformType.STATIC and enemy_scene and enemy_gap_ok and randf() < enemy_chance:
		var enemy = enemy_scene.instantiate()
		enemy.global_position = platform.global_position + Vector2(0, -42)
		add_child(enemy)
		last_enemy_y = last_spawn_y
		return

	var shop_gap_ok = abs(last_spawn_y - last_shop_y) >= MIN_SHOP_GAP
	if type == PlatformType.STATIC and shop_scene and shop_gap_ok and randf() < BASE_SHOP_CHANCE:
		var shop = shop_scene.instantiate()
		shop.global_position = platform.global_position + Vector2(0, -42)
		add_child(shop)
		last_shop_y = last_spawn_y

func _get_random_platform_type(d: float) -> PlatformType:
	var static_chance = lerpf(0.7, 0.3, d)
	var moving_chance = lerpf(0.2, 0.3, d)
	var roll = randf()
	if roll < static_chance:
		return PlatformType.STATIC
	elif roll < static_chance + moving_chance:
		return PlatformType.MOVING
	else:
		return PlatformType.BREAKING

func _get_platform_by_type(type: PlatformType) -> Node2D:
	match type:
		PlatformType.MOVING:   return moving_platform.instantiate()
		PlatformType.BREAKING: return breaking_platform.instantiate()
		_:                     return static_platform.instantiate()
