extends CanvasLayer


signal next_button_pressed


func _ready():
	$Control.modulate = Color(1, 1, 1, 0)


func show(score, time):
	$Control/Sprite.modulate = Color(1, 1, 1, 0)
	$Control/ScoreTitle.modulate = Color(1, 1, 1, 0)
	$Control/ScoreValue.modulate = Color(1, 1, 1, 0)
	$Control/TimeTitle.modulate = Color(1, 1, 1, 0)
	$Control/TimeValue.modulate = Color(1, 1, 1, 0)
	$Control/TextureButton.modulate = Color(1, 1, 1, 0)
	
	$Control.modulate = Color(1, 1, 1, 1)
		
	$Control/ScoreValue.text = str(score)
	$Control/TimeValue.text = time
	
	scale = Vector2(1, 1)
	
	$Tween.interpolate_property($Control/Sprite, 'modulate', Color(1, 1, 1, 0), Color(1, 1, 1, 0.9),
		3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	
	$Tween.interpolate_property($Control/ScoreTitle, 'modulate', Color(1, 1, 1, 0), Color(1, 1, 1, 0.9),
		2, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.3)
		
	$Tween.interpolate_property($Control/ScoreValue, 'modulate', Color(1, 1, 1, 0), Color(1, 1, 1, 0.9),
		2, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.6)
		
	$Tween.interpolate_property($Control/TimeTitle, 'modulate', Color(1, 1, 1, 0), Color(1, 1, 1, 0.9),
		2, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.9)
		
	$Tween.interpolate_property($Control/TimeValue, 'modulate', Color(1, 1, 1, 0), Color(1, 1, 1, 0.9),
		2, Tween.TRANS_CUBIC, Tween.EASE_OUT, 1.2)
		
	$Tween.interpolate_property($Control/TextureButton, 'modulate', Color(1, 1, 1, 0), Color(1, 1, 1, 0.9),
		2, Tween.TRANS_CUBIC, Tween.EASE_OUT, 1.5)
	
	$Tween.start()
	
	
func hide():
	$Tween.interpolate_property($Control, 'modulate', Color(1, 1, 1, 1), Color(1, 1, 1, 0),
		0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		
	$Tween.start()
	
	
func _on_TextureButton_pressed():
	emit_signal("next_button_pressed")