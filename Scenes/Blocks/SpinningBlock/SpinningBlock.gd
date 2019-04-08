extends "res://Scenes/Blocks/Block/Block.gd"
class_name SpinningBlock


onready var default_rotation = rotation

var is_spinning = false


func _process(delta):
	if is_spinning:
		self.rotate(deg2rad(50) * delta)
	
	
func activate():
	.activate()
	
	is_spinning = true
	
func deactivate():
	.deactivate()
	
	is_spinning = false


func reset():
	rotation = default_rotation
	