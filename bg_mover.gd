extends Sprite2D

@export var camera: Camera2D
@export var parallax_speed: float = 0.02

func _ready():
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	region_enabled = true
	z_index = -1
	var vp = get_viewport_rect().size
	var tex = texture.get_size()
	scale = Vector2(vp.x / tex.x, vp.y / tex.y)

func _process(_delta):
	if camera == null:
		return
	var canvas_transform = get_viewport().get_canvas_transform()
	var vp_size = get_viewport_rect().size
	var screen_center = canvas_transform.affine_inverse() * (vp_size / 2.0)

	global_position = screen_center
	var tex = texture.get_size()
	region_rect = Rect2(0, screen_center.y * parallax_speed, tex.x, tex.y)
