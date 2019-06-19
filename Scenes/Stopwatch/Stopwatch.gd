extends Node2D
class_name Stopwatch


var seconds_elapsed = 0.0


func _ready():
	set_process(false)
	

func _process(delta):
	seconds_elapsed += delta
	

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
	seconds_elapsed = 0.0
	
	
func to_string(padded = true):
	var m = floor(seconds_elapsed / 60)
	var s = int(seconds_elapsed) % 60
	
	var time_string = ""
	time_string += str(m) + ":"
	if s < 10:
		time_string += "0"
	time_string += str(s)
	
	return time_string
	