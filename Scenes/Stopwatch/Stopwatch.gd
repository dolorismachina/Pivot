extends Node2D
class_name Stopwatch


var milliseconds = 0 setget , get_milliseconds
var seconds = 0 setget , get_seconds
var minutes = 0 setget , get_minutes 


func _ready():
	set_process(false)
	

func _process(delta):
	milliseconds += floor(delta * 1000)
	seconds = milliseconds / 1000
	minutes = seconds / 60
	

func start():
	reset()
	set_process(true)
	

func stop():
	set_process(false)


func pause():
	set_process(false)
	

func resume():
	set_process(true)
	

func reset():
	milliseconds = 0
	seconds = 0
	minutes = 0


func get_milliseconds():
	return  milliseconds
	

func get_seconds():
	return milliseconds / 1000
	
	
func get_minutes():
	return milliseconds / 1000 / 60.0
	
	
func to_string(padded = true):
	var m = floor(seconds / 60)
	var s = int(seconds) % 60
	
	var time_string = ""
	time_string += str(m) + ":"
	if s < 10:
		time_string += "0"
	time_string += str(s)

	print("String: ", time_string)
	
	return time_string
	