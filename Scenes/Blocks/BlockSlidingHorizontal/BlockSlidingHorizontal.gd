extends "res://Scenes/Blocks/Block/Block.gd"

func _ready():
	pass

func activate():
	.activate()
	
	$AnimationPlayer.play("slide")