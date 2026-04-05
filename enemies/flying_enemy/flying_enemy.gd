extends CharacterBody2D

@export var speed: float = 100.0
@export var move_range: float = 150.0
@export var shoot_interval: float = 1.5
@export var bullet_scene: PackedScene
@export var gear_scene: PackedScene

var _start_x: float
var _direction: float = 1.0

@onready var shoot_timer: Timer = $ShootTimer
@onready var marker: Marker2D = $Marker2D
@onready var notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func die():
	if gear_scene == null:
		return
	var gear = gear_scene.instantiate()
	gear.global_position = global_position
	get_tree().current_scene.add_child.call_deferred(gear)
	queue_free()


func _ready():
	_start_x = global_position.x
	shoot_timer.wait_time = shoot_interval
	shoot_timer.timeout.connect(_shoot)
	shoot_timer.start()
	notifier.screen_exited.connect(queue_free)

func _physics_process(_delta):
	velocity.x = speed * _direction

	# разворот при достижении границы патруля
	if global_position.x > _start_x + move_range:
		_direction = -1.0
	elif global_position.x < _start_x - move_range:
		_direction = 1.0

	move_and_slide()

func _shoot():
	if bullet_scene == null:
		return
	var bullet = bullet_scene.instantiate()
	bullet.global_position = marker.global_position
	get_tree().current_scene.add_child(bullet)
