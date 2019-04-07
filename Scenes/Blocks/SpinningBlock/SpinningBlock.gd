extends "res://Scenes/Blocks/Block/Block.gd"
class_name SpinningBlock


onready var default_rotation = rotation

func _process(delta):
	self.rotate(deg2rad(50) * delta)
	

func reset():
	rotation = default_rotation
	