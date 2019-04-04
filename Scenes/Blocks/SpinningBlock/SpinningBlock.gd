extends "res://Scenes/Blocks/Block/Block.gd"
class_name SpinningBlock


func _process(delta):
	self.rotate(deg2rad(50) * delta)