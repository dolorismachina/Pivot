extends Node2D
class_name LevelController

enum Direction {LEFT = -1, RIGHT = 1}

onready var pivot : Node2D = null
var is_enabled = false

var is_rotating = false
export (int) var rotation_angle = 45
var tween_speed = 0.15
export (int) var max_rotation = 90

var transition_type = Tween.TRANS_QUAD
var ease_type = Tween.EASE_IN


func _ready():
	pivot = get_parent().get_node('Pivot') 
	
	set_process_input(false)
	
	
func _input(event):
	if is_rotating:
		return
		
	if event.is_action_pressed("ui_right"):
		if pivot.rotation_degrees >= max_rotation:
			return
			
		rotate_level(Direction.RIGHT)
		
	if event.is_action_pressed("ui_left"):
		if pivot.rotation_degrees <= -max_rotation:
			return
			
		rotate_level(Direction.LEFT)
	

func rotate_level(direction):
	is_rotating = true
	
	$Tween.interpolate_property(pivot, 'rotation', 
		pivot.rotation, pivot.rotation + deg2rad(rotation_angle * direction), 
		tween_speed, transition_type, ease_type)
			
	$Tween.start()
	
	get_parent().emit_signal("rotated", direction, rotation_angle)
	
	
func _on_Tween_tween_completed(object, key):
	is_rotating = false
	

func _on_SwipeDetector_swipe_ended(gesture):
	if not is_enabled:
		return
		
	match gesture.get_direction():
		'right':
			rotate_level(1)
		'left':
			rotate_level(-1)


func enable():
	set_process_input(true)
	is_enabled = true
	
	
func disable():
	set_process_input(false)
	is_enabled = false
	