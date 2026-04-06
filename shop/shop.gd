extends CharacterBody2D

const PRICES = {
	"gun":    50,
	"level1": 30,
	"level2": 80,
	"level3": 150,
	"level4": 300,
}

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
		if SaveManager.gears >= PRICES["gun"]:
			SaveManager.GUN1111()
			SaveManager.remove_gears(PRICES["gun"])
		queue_free()
		

func _on_gui_closed():
	gui_open = false
