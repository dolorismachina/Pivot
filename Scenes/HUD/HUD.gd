extends CanvasLayer

signal reset

func _on_ResetButton_pressed():
	emit_signal("reset")
	
func update_score(value):
	$MarginContainer/Score.text = str(value)
	