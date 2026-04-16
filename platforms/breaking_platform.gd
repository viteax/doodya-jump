extends StaticBody2D

@export var break_delay: float = 0.3
@export var shake_before_break: bool = true
@export var respawn_time: float = 0.0

var _breaking = false
@onready var timer: Timer = $Timer
@onready var area: Area2D = $Area2D
var _original_position: Vector2

func _ready():
	_original_position = global_position
	timer.one_shot = true
	timer.timeout.connect(_break)

func _physics_process(_delta):
	if _breaking:
		return
	for body in area.get_overlapping_bodies():
		if body.is_in_group("player") and body.is_on_floor():
			_breaking = true
			timer.wait_time = break_delay
			timer.start()
			if shake_before_break:
				_shake()
			break

func _shake():
	var tween = create_tween()
	for i in 4:
		tween.tween_property(self, "position:x", _original_position.x + 2, 0.04)
		tween.tween_property(self, "position:x", _original_position.x - 2, 0.04)

func _break():
	if respawn_time > 0:
		visible = false
		$CollisionShape2D.set_deferred("disabled", true)
		get_tree().create_timer(respawn_time).timeout.connect(_respawn)
	else:
		queue_free()

func _respawn():
	global_position = _original_position
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)
	_breaking = false
