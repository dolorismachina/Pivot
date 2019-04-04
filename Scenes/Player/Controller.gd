extends Node2D

var player : Player
var vel = Vector2()

func _ready():
	player = get_parent()
	
func _unhandled_input(event):
	return
	if not event.is_pressed():
		vel = Vector2(0, 0)
		
	if event.is_action_pressed("ui_left"):
		vel = Vector2(-1, 0)
		player.velocity += Vector2(-100, 0)
				
	if event.is_action_pressed("ui_right"):		
		vel = Vector2(1, 0)
		player.velocity += Vector2(100, 0)
