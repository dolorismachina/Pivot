extends Sprite


func _on_TextureButton_pressed():
	visible = false
	get_parent().get_node("LevelSelect").visible = true
	