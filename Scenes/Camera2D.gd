extends Camera2D


export (Vector2) var zoom_desktop = Vector2(1, 1)
export (Vector2) var zoom_mobile = Vector2(0.5, 0.5)


func _ready():
	match OS.get_name():
		'Windows':
			zoom = zoom_desktop
		'Android':
			zoom = zoom_mobile
