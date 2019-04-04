extends Area2D


var t = 0.0

func _ready():
	print(is_in_group("enemies"))

func _process(delta):
	t += delta
	
	position.x += cos(t) * 3