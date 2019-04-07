extends Node2D


signal tilt_start

enum TiltDirection { LEFT = -1, RIGHT = 1, NONE = 0 }
var tilt_direction = TiltDirection.NONE


func _ready():
	set_process(false)
func _process(delta):
	
	if not OS.get_name() == 'Android' or not OS.get_name() == 'iOS':
		return
		
	var accelerometer = average(Input.get_accelerometer(), 0)
	print(name, Input.get_accelerometer().normalized())
	
	
	if accelerometer.x < -0:
		tilt_direction = TiltDirection.LEFT
	if accelerometer.x > 0:
		tilt_direction = TiltDirection.RIGHT
	if accelerometer.x > -0 and accelerometer.x < 0:
		tilt_direction = TiltDirection.NONE
	
	var diff = abs(accelerometer.x)
	var clamped = clamp(diff, 0, 3)
	
	get_parent().get_node('Pivot').rotation_degrees = clamped * tilt_direction * 10
	
	
var avg = []
func average(acceleration : Vector3,  delta : float) -> Vector3:
	if avg.size() == 6:
		avg.pop_front()
	
	avg.push_back(acceleration)
	
	var av = Vector3()
	
	for i in avg:
		av += i
		
	av = av / avg.size()
	
	return av
		
func rotate(direction) -> void:
	pass
	