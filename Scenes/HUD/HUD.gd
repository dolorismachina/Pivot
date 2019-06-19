extends CanvasLayer


signal reset


func _on_ResetButton_pressed():
	emit_signal("reset")
	
	
func update_score(value):
	$VBoxContainer/Score.text = str(value)
	

func update_time(value):
	$VBoxContainer/Time.text = value
	

func hide():
	$VBoxContainer.visible = false
	

func show():
	$VBoxContainer.visible = true	
	