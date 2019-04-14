extends CanvasLayer


signal reset


func _on_ResetButton_pressed():
	emit_signal("reset")
	
	
func update_score(value):
	$VBoxContainer/Score.text = str(value)
	

func update_time(value):
	var s = ''
	if value.second < 10:
		s = '0' + str(value.second)
	else:
		s = str(value.second)
	$VBoxContainer/Time.text = str(value.minute) + ':' + s
	

func hide():
	$VBoxContainer.visible = false
	

func show():
	$VBoxContainer.visible = true	
	