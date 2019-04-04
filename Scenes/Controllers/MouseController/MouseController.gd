extends Node2D

var screen_centre : Vector2 = Vector2()
var original_rotation

var player_position : Vector2 = Vector2()


export (bool) var enabled = true

func _ready():
	original_rotation = get_parent().rotation
	screen_centre = get_viewport_rect().size / 2
	print(screen_centre)


func _unhandled_input(event):
	if not event is InputEventMouseMotion:
		return
		
	if not enabled:
		return
		
	var a : float = 45 / 360.0
	
	var mouse_to_centre : Vector2 = event.position - screen_centre
	var mouse_to_player : Vector2 = event.position - player_position
	print(mouse_to_player)
	get_parent().get_node('Pivot').rotation = deg2rad(original_rotation + a * mouse_to_centre.x * -1)
	

func update_position(position):
	player_position = position