extends Area2D

@export var speed: float = 200.0
var direction: Vector2 = Vector2.DOWN
var color: Color

@onready var notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready():
	var lifetime_timer = get_tree().create_timer(5.0)
	lifetime_timer.timeout.connect(queue_free)
	body_entered.connect(_on_body_entered)
	notifier.screen_exited.connect(queue_free)

func _draw():
	draw_circle(Vector2.ZERO, 15, Color.RED)
	if color:
		draw_circle(Vector2.ZERO, 15, color)

func _physics_process(delta):
	position.y += direction.y * speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().reload_current_scene.call_deferred()
		return
	body.die()
	queue_free()
