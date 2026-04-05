extends Area2D

@export var speed: float = 200.0

func _ready():
	var lifetime_timer = get_tree().create_timer(5.0)
	lifetime_timer.timeout.connect(queue_free)
	body_entered.connect(_on_body_entered)

func _draw():
	draw_circle(Vector2.ZERO, 15, Color.RED)

func _physics_process(delta):
	position.y += speed * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(1)
	queue_free()
