extends Node2D

class_name LevelController


enum Direction {LEFT, RIGHT}


onready var pivot : Node2D = null

var is_rotating = false
export (int) var rotation_angle = 10
var tween_speed = 0.20


func _ready():
	pivot = get_parent().get_node('Pivot') 
	
	set_process_input(true)
	
	
func _input(event):
	if is_rotating:
		return
		
	if event.is_action_pressed("ui_right"):
		rotate_level(Direction.RIGHT)
		
	if event.is_action_pressed("ui_left"):
		rotate_level(Direction.LEFT)


func rotate_level(direction):
	is_rotating = true
	
	if direction == Direction.LEFT:
		$Tween.interpolate_property(pivot, 'rotation', 
			pivot.rotation, pivot.rotation + deg2rad(-rotation_angle), 
			tween_speed, Tween.TRANS_QUAD, Tween.EASE_IN)
			
	elif direction == Direction.RIGHT:
		$Tween.interpolate_property(pivot, 'rotation', 
			pivot.rotation, pivot.rotation + deg2rad(rotation_angle), 
			tween_speed, Tween.TRANS_QUAD, Tween.EASE_IN)
			
	$Tween.start()
		
	
func _on_Tween_tween_completed(object, key):
	is_rotating = false
	