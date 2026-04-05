extends StaticBody2D

@export var break_delay: float = 0.3
@export var shake_before_break: bool = true
@export var respawn_time: float = 0.0  # 0 = не респавнится

var _breaking = false
@onready var timer: Timer = $Timer
var _original_position: Vector2

func _ready():
	_original_position = global_position
	timer.one_shot = true
	timer.timeout.connect(_break)
	$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is CharacterBody2D and not _breaking:
		if body.velocity.y >= 0 and body.global_position.y < global_position.y:
			_breaking = true
			timer.wait_time = break_delay
			timer.start()
			if shake_before_break:
				_shake()

func _shake():
	var tween = create_tween()
	for i in 4:
		tween.tween_property(self, "position:x",
			_original_position.x + 2, 0.04)
		tween.tween_property(self, "position:x",
			_original_position.x - 2, 0.04)

func _break():
	if respawn_time > 0:
		# прячем, потом восстанавливаем
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
