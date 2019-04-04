extends Area2D
class_name Collectable


export (int) var value = 100


func _process(delta):
	rotate(deg2rad(20) * delta)


func collect():
	$TweenScale.interpolate_property($Sprite, 'scale', $Sprite.scale, 
		Vector2(3, 3), 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$TweenScale.start()
	
	$TweenOpacity.interpolate_property($Sprite, 'modulate', $Sprite.modulate, 
		Color(0, 0, 0, 0), 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$TweenOpacity.start()