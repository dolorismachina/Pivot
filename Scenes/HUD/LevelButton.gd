extends TextureButton

signal level_selected(id)

export (int) var level_id

func _ready():
	$Label.text = str(level_id)


func _on_LevelButton_pressed():
	emit_signal("level_selected", level_id)
