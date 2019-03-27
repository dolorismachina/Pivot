extends CanvasLayer

signal reset

func _on_ResetButton_pressed():
	emit_signal("reset")