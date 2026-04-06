extends Sprite2D

@export var camera: Camera2D

func _process(_delta):
	if camera == null:
		return
	global_position.y = -600 + camera.global_position.y
