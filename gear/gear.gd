extends Area2D


func _on_body_entered(_body: Node2D) -> void:
	SaveManager.add_gears(1)
	print(SaveManager.gears)
	queue_free()
