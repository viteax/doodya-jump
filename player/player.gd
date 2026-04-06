extends CharacterBody2D


const SPEED = [ 500, 620, 760, 900, 1050 ]
const JUMP_VELOCITY = [ -750, -800, -920, -1050, -1200 ]

@export var bullet_scene: PackedScene

@onready var camera: Camera2D = $Camera2D
@onready var sprite: AnimatedSprite2D = $CollisionShape2D/body_AnimatedSprite2D
@onready var arm_sprite: AnimatedSprite2D = $CollisionShape2D/arms_AnimatedSprite2D

var start_y: float = 0.0
var max_height: float = 0.0

@onready var height_label: Label = get_node("/root/Main/CanvasLayer0/HeightLabel")
@onready var gears_label: Label = get_node("/root/Main/CanvasLayer0/GearsLabel")

func _ready():
	start_y = global_position.y
	play_synced()
	
func play_synced() -> void:
	sprite.play("body_lvl0_jmp")
	arm_sprite.play("jmp")
	arm_sprite.frame = sprite.frame

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
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if is_on_floor():
		velocity.y = JUMP_VELOCITY[SaveManager.level]

	move_and_slide()
	
	var current_height = (start_y - global_position.y) / 100.0
	
	if current_height > max_height:
		max_height = current_height
		height_label.text = "Height: %dm" % int(max_height)
		
	gears_label.text = "%d Gears" % int(SaveManager.gears)

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
		velocity.x = direction * SPEED[SaveManager.level]
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED[SaveManager.level])

	
