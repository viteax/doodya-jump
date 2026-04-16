extends Node

# Единая точка расчёта сложности для всех спаунеров.
# Сложность от 0.0 (старт) до 1.0 (максимум) на основе высоты камеры.

const START_Y: float = 427.0
const RAMP: float = 24000.0

func get_d(camera_y: float) -> float:
	var height = START_Y - camera_y
	return clampf(height / RAMP, 0.0, 1.0)
