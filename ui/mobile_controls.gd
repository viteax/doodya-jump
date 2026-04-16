extends CanvasLayer

var _touches: Dictionary = {}

func _ready():
	visible = DisplayServer.is_touchscreen_available()

func _input(event):
	if not visible:
		return

	if event is InputEventScreenTouch:
		if event.pressed:
			_touches[event.index] = event.position
			# стрельба — одиночный tap в верхней зоне
			var screen_h = get_viewport().get_visible_rect().size.y
			if event.position.y <= screen_h * 0.6:
				_fire_action("shoot")
		else:
			_touches.erase(event.index)
		_update_movement()

	elif event is InputEventScreenDrag:
		_touches[event.index] = event.position
		_update_movement()

func _update_movement():
	var screen_center = get_viewport().get_visible_rect().size.x / 2.0
	var screen_h = get_viewport().get_visible_rect().size.y
	var left = false
	var right = false

	for pos in _touches.values():
		if pos.y > screen_h * 0.6:
			if pos.x < screen_center:
				left = true
			else:
				right = true

	_set_action("ui_left", left)
	_set_action("ui_right", right)

# Генерирует реальный InputEvent — триггерит _input(event) у подписчиков
func _fire_action(action: String):
	var ev = InputEventAction.new()
	ev.action = action
	ev.pressed = true
	Input.parse_input_event(ev)
	ev = InputEventAction.new()
	ev.action = action
	ev.pressed = false
	Input.parse_input_event(ev)

func _set_action(action: String, pressed: bool):
	if pressed:
		Input.action_press(action)
	else:
		Input.action_release(action)
