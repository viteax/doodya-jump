extends CharacterBody2D

const SPEED = [ 500, 620, 760, 900, 1050 ]
const JUMP_VELOCITY = [ -750, -800, -920, -1050, -1200 ]

@export var bullet_scene: PackedScene
@export var game_over_scene: PackedScene
@export var height_label: Label
@export var gears_label: Label
@export var best_label: Label

@onready var camera: Camera2D = $Camera2D
@onready var sprite: AnimatedSprite2D = $CollisionShape2D/body_AnimatedSprite2D
@onready var arm_sprite: AnimatedSprite2D = $CollisionShape2D/arms_AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer = $JumpSound

var start_y: float = 0.0
var max_height: float = 0.0
var _was_on_floor: bool = false

var _ghost: Node2D
var _ghost_body: AnimatedSprite2D
var _ghost_arms: AnimatedSprite2D

func _ready():
	start_y = global_position.y
	play_synced()
	SaveManager.gears_changed.connect(_on_gears_changed)
	_on_gears_changed(SaveManager.gears)
	_create_ghost()
	if best_label:
		if SaveManager.best_height > 0:
			best_label.text = "Рекорд: %dм" % SaveManager.best_height
		else:
			best_label.text = ""

func _create_ghost():
	_ghost = Node2D.new()
	_ghost_body = sprite.duplicate()
	_ghost_arms = arm_sprite.duplicate()
	_ghost.add_child(_ghost_body)
	_ghost.add_child(_ghost_arms)
	add_child(_ghost)

func play_synced() -> void:
	# отключаем зацикливание
	sprite.sprite_frames.set_animation_loop("body_lvl0_jmp", false)
	arm_sprite.sprite_frames.set_animation_loop("jmp", false)
	sprite.animation_finished.connect(func(): sprite.pause())
	arm_sprite.animation_finished.connect(func(): arm_sprite.pause())

func _update_animation():
	var on_floor = is_on_floor()
	if _was_on_floor and not on_floor:
		sprite.play("body_lvl0_jmp")
		arm_sprite.play("jmp")
	_was_on_floor = on_floor

func _update_ghost(screen_w: float):
	_ghost_body.animation = sprite.animation
	_ghost_body.frame = sprite.frame
	_ghost_arms.animation = arm_sprite.animation
	_ghost_arms.frame = arm_sprite.frame

	if global_position.x < screen_w / 2.0:
		_ghost.position.x = screen_w
	else:
		_ghost.position.x = -screen_w

func _on_gears_changed(amount: int):
	if gears_label:
		gears_label.text = "%d Gears" % amount

func die():
	SaveManager.last_session_height = int(max_height)
	SaveManager.last_session_gears = SaveManager.gears
	SaveManager.update_best_height(int(max_height))
	SaveManager.reset()
	var overlay = game_over_scene.instantiate()
	get_tree().current_scene.add_child(overlay)

func _input(event):
	if event.is_action_pressed("shoot"):
		if SaveManager.has_gun:
			_shoot()

func _shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = $Marker2D.global_position
	bullet.direction = Vector2.UP
	bullet.speed = 800
	bullet.color = Color.YELLOW
	get_tree().current_scene.add_child(bullet)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED[SaveManager.level]
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED[SaveManager.level])

	move_and_slide()

	if is_on_floor():
		velocity.y = JUMP_VELOCITY[SaveManager.level]
		jump_sound.play()

	var screen_w = get_viewport_rect().size.x
	if global_position.x < 0:
		global_position.x = screen_w
	elif global_position.x > screen_w:
		global_position.x = 0
	_update_animation()
	_update_ghost(screen_w)

	var current_height = (start_y - global_position.y) / 24.0
	if current_height > max_height:
		max_height = current_height
		if height_label:
			height_label.text = "Height: %dm" % int(max_height)
		if best_label and int(max_height) > SaveManager.best_height:
			best_label.text = "Рекорд: %dм" % int(max_height)

	camera.limit_bottom = min(
		global_position.y + get_viewport_rect().size.y / 3,
		camera.limit_bottom,
	)

	if camera.limit_bottom < global_position.y:
		die()
