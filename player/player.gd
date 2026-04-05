extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -750.0

@export var bullet_scene: PackedScene

@onready var camera: Camera2D = $Camera2D

func _input(event):
	if event.is_action_pressed("shoot"):
		_shoot()

func _shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = $Marker2D.global_position
	bullet.direction = Vector2.UP
	bullet.speed = 800
	bullet.color = Color.YELLOW
	get_tree().current_scene.add_child(bullet)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if is_on_floor():
		velocity.y = JUMP_VELOCITY

	camera.limit_bottom = min(
		global_position.y + get_viewport_rect().size.y / 3,
		camera.limit_bottom,
	)
	
	if camera.limit_bottom < global_position.y:
		get_tree().reload_current_scene()
		return

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
