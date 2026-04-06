extends CharacterBody2D

@onready var area_2d: Area2D = $Area2D
@onready var notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

@export var shop_gui_scene: PackedScene

var gui_open := false

func _ready():
	area_2d.body_entered.connect(_on_body_entered)
	notifier.screen_exited.connect(queue_free)
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	
func _on_body_entered(body):
	if body.is_in_group("player") and not gui_open:
			gui_open = true
			var gui = shop_gui_scene.instantiate()
			gui.closed.connect(_on_gui_closed)
			get_tree().current_scene.add_child(gui)
			get_tree().paused = true
			
func _on_gui_closed():
	gui_open = false
			
